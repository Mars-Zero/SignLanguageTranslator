import 'package:flutter/material.dart';

class InstructionsPopUp extends StatelessWidget {
  const InstructionsPopUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
  }
}