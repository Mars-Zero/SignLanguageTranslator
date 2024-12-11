import 'package:flutter/material.dart';
import 'package:sign_language_translator/camera.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key
    });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final GlobalKey<CameraState> _cameraKey = GlobalKey<CameraState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Language Translator',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 2),
            Container(
              constraints: const BoxConstraints(maxHeight: 400),
              child: Camera(key: _cameraKey), // ma folosesc de key pt a accesa metodele clasei Camera.
            ),
            const SizedBox(height: 110),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _cameraKey.currentState?.startOrResetTranslation();
                  },
                  child: const Text('Start Translation'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    showInstructionsDialog(context);
                  },
                  child: const Text('Help'),
                ),
              ],
            ),
            const Text(
              'Sign Language Translator',
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void showInstructionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usage Instructions'),
          content: const Text('Follow the steps below:\n'
              '1. Use the camera to capture the signs.\n'
              '2. Perform the signs as clearly as possible and allow at least one second between consecutive representations.\n'
              '3. If you want to rotate the camera, press the button in the top right corner.\n'
              '4. Press the Start Translation button to begin the translation process.\n'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}