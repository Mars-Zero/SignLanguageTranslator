import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});
  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool isRearCamera = true;

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
    cameraController.initialize();
  }

  @override
  void initState() {
    _initCameras().then((value) => startCamera(0));
    super.initState();
  }

  @override
  void dispose() {
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
                            child: CameraPreview(cameraController)),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5, top: 10),
                        child: Container(
                          alignment: Alignment.topRight,
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
                                        size: 30,
                                      )
                                    : const Icon(
                                        Icons.camera_rear,
                                        color: Colors.white,
                                        size: 30,
                                      ),
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
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
