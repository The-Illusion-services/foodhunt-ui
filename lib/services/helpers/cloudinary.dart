import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  final String cloudName = "khervie00";
  final String apiKey = "833625513281744";
  final String apiSecret = "3B98pgkr3fT4P8YZQ2vmEy0howI";

  /// Function to pick an image using ImagePicker
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  /// Function to upload image to Cloudinary
  Future<String?> uploadImage(File imageFile) async {
    try {
      // Prepare Cloudinary API endpoint
      final url =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      // Generate a unique name for the file (optional)
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a multipart request
      final request = http.MultipartRequest('POST', url);

      // Add required fields
      request.fields['upload_preset'] = 'foodhunt';
      request.fields['public_id'] = "flutter_upload_$timestamp";

      // Add the image file to the request
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      // Send the request
      final response = await request.send();

      // Process the response
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final Map<String, dynamic> result = jsonDecode(responseData);
        return result['secure_url'];
      } else {
        throw Exception("Failed to upload image: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during image upload: $e");
      return null;
    }
  }
}
