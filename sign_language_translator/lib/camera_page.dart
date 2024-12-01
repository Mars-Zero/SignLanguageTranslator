import 'package:flutter/material.dart';
import 'package:sign_language_translator/camera.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Language Translator',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          children: [
            // const SizedBox(height: 20),
            Container(
              constraints: BoxConstraints(
                maxHeight: 500,
              ),
              child: Camera(),
            ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {},
            //   child: const Text('Start Translation'),
            // ),
          ],
        ),
      ),
    );
  }
}