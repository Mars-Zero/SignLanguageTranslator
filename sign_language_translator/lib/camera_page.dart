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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 2),
            Container(
              constraints: BoxConstraints(
                maxHeight: 400,
              ),
              child: Camera(),
            ),
            const SizedBox(height: 110),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Start Translation'),
            ),
            Text(
              'Sign Language Translator',
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}