import 'package:flutter/material.dart';
import 'package:sign_language_translator/components/camera.dart';
import 'package:sign_language_translator/components/instructions_pop_up.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final GlobalKey<CameraState> _cameraKey = GlobalKey<CameraState>();
  bool _isTranslating = false;

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
              child: Camera(key: _cameraKey),
            ),
            const SizedBox(height: 110),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_isTranslating) {
                        _cameraKey.currentState?.stopTranslationAndSendToLLM();
                      } else {
                        _cameraKey.currentState?.startOrResetTranslation();
                      }
                      _isTranslating = !_isTranslating;
                    });
                  },
                  child: Text(
                      _isTranslating ? 'Stop Translation' : 'Start Translation'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return InstructionsPopUp();
                      },
                    );
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
}
