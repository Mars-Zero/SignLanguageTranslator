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

  Future<String> getTranslation() async {
    final url = Uri.parse('$_baseUrl/translate');

    try {
      var response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('Translation: ${responseBody['translation']}');
        return responseBody['translation'];
      }
    } catch (e) {
      print('Eroare: $e');
      return "Error transalting your message";
    }
    return "";
  }
}
