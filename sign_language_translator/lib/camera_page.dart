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
          title: const Text('Instrucțiuni de folosire'),
          content: const Text(
            'Urmati pasii urmatori:\n'
            '1. Utilizati camera pentru a captura semnele.\n'
            '2. Exectutati semnele cat mai clar si lasati sa treaca macar o secunda intre doua reprezentari consecutive.\n'
            '3. Daca doriti rotirea camerei, apasati pe butonul din coltul din dreapta, sus.\n'
            '4. Apasati butonul Start Translation pentru a incepe procesul de translatarea\n'
            ,
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