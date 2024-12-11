import 'dart:async'; // Adăugat pentru a folosi Timer-ul
import 'dart:typed_data'; // Adăugat pentru a manipula fișierele în format de bytes
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Importăm pachetul http pentru a trimite cereri

class Camera extends StatefulWidget {
  const Camera({super.key});
  @override
  State<Camera> createState() => CameraState();
}

class CameraState extends State<Camera> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool isRearCamera = true;
  Timer?
      _timer; // un timer pentru a putea trimite imaginile din cateva milisecunde
  // in cateva milisecunde.

  void startCamera(int camera) async {
    cameraController = CameraController(
      cameras[camera],
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<void> _initCameras() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await cameraController.initialize();
  }

  @override
  void initState() {
    super.initState();
    _initCameras().then((value) => startCamera(0));
  }

  @override
  void dispose() {
    _timer?.cancel(); // Oprire timer când widget-ul este distrus
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: availableCameras(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Stack(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: 100,
                      child: Transform(
                        alignment: Alignment.center,
                        transform:
                            Matrix4.rotationY(isRearCamera ? 0 : 3.14159),
                        child: CameraPreview(cameraController),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5, top: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isRearCamera = !isRearCamera;
                          });
                          isRearCamera ? startCamera(0) : startCamera(1);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(50, 0, 0, 0),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: isRearCamera
                                ? const Icon(
                                  Icons.camera_front,
                                  color: Colors.white,
                                  size: 30
                                )
                                : const Icon(Icons.camera_rear,
                                  color: Colors.white,
                                  size: 30
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator()
            );
        }
      },
    );
  }

  void _startSendingImages() {
    _timer?.cancel(); // oprirea timer-ului existent
    // executa o functie anonimă la fiecare 500 ms, adica aceea in care preiau poza, o citesc ca pe o lista de biti
    // cu .readAsBytes(), apoi execut functia in care trimit imaginea la server.
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (cameraController.value.isInitialized &&
          !cameraController.value.isTakingPicture) {
        try {
          final image = await cameraController.takePicture();
          final imageBytes = await image.readAsBytes();
          await sendImageToServer(imageBytes);
        } catch (e) {
          print('Error in image processing: $e');
        }
      }
    });
  }

  // Metoda pentru resetarea procesului de trimitere al imaginilor.
  void startOrResetTranslation() {
    _startSendingImages(); // trimit imaginile
  }

  Future<void> sendImageToServer(Uint8List imageBytes) async {
    final url = Uri.parse('http://192.168.182.86:5000/upload');

    try {
      // Incarc fisierele catre server, apoi atasez imaginea requestului folosind fromBytes, dandu-i numele image.jpg.
      var request = http.MultipartRequest('POST', url);
      request.files.add(http.MultipartFile.fromBytes('file', imageBytes,
          filename: 'image.jpg'));

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image sent with succes!');
      } else {
        print('Failed to send the image:( -> ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
