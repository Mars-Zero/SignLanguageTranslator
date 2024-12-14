import 'dart:typed_data'; // pentru a manipula fișierele în format de bytes
import 'dart:convert'; // pentru json
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Network {
  final _baseUrl = dotenv.env['API_BASE_URL'];

  Future<void> sendImageToServer(Uint8List imageBytes) async {
    final url = Uri.parse('$_baseUrl/upload');

    try {
      print('Image size: ${imageBytes.length} bytes');

      var request = http.MultipartRequest('POST', url);
      request.files.add(http.MultipartFile.fromBytes('file', imageBytes,
          filename: 'image.jpg'));

      var response = await request.send();
      print("Sending request...");
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Server response: $responseBody');
      } else {
        print('Failed to send the image: ${response.statusCode}');
        final responseBody = await response.stream.bytesToString();
        print('Error response body: $responseBody');
      }
    } catch (e) {
      print('Error sending image: $e');
    }
  }

  Future<void> sendOutputsToLLM(List<String> translationOutputs) async {
    final url = Uri.parse('$_baseUrl/processing_translate');

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'translations': translationOutputs}),
      );

      if (response.statusCode == 200) {
        print('Procesarea a fost incheiata cu succes!');
        print('answer from LLM: ${response.body}');
      }
    } catch (e) {
      print('Eroare: $e');
    }
  }
}
