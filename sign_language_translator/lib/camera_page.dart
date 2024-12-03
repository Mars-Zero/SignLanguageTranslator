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
            // plasez butonul de "Start Translation si cel de Help pe aceeasi linie."
            Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // aici sa am butonul de start translation, in partea stanga a ecranului.
              ElevatedButton(
                onPressed: () {},
                child: const Text('Start Translation'),
              ),
            // un padding de 20 px stanga dreapta intre cele doua butoane.
            const SizedBox(width: 20), 
            ElevatedButton(
              onPressed: () {showInstructionsDialog(context);},
              child: const Text('Help'),
            ),
          ],
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

  // Metoda pentru afisarea unei casute de instructiuni, widget care are atat titlu,
  // parte de continut(text), dar si buton de inchidere, "Close"
  void showInstructionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
        title: const Text('Usage Instructions'),
        content: const Text(
          'Follow the steps below:\n'
          '1. Use the camera to capture the signs.\n'
          '2. Perform the signs as clearly as possible and allow at least one second between consecutive representations.\n'
          '3. If you want to rotate the camera, press the button in the top right corner.\n'
          '4. Press the Start Translation button to begin the translation process.\n'
        ),
          actions: <Widget>[
            TextButton(
              onPressed: () { Navigator.of(context).pop(); }, // inchid dialogul
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}