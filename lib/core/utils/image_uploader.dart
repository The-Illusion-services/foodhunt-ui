import 'package:flutter/material.dart';
import 'dart:io';

class ImagePickerUploader extends StatefulWidget {
  final Future<File?> Function() pickImage;
  final Future<String?> Function(File) uploadImage;
  final void Function(String url)? onUploadComplete;

  const ImagePickerUploader({
    Key? key,
    required this.pickImage,
    required this.uploadImage,
    this.onUploadComplete,
  }) : super(key: key);

  @override
  _ImagePickerUploaderState createState() => _ImagePickerUploaderState();
}

class _ImagePickerUploaderState extends State<ImagePickerUploader> {
  bool _isUploading = false;
  File? _selectedImage;
  String? _uploadedImageUrl;

  Future<void> _pickAndUploadImage() async {
    try {
      final File? image = await widget.pickImage();
      if (image != null) {
        if (_isImageSizeValid(image)) {
          setState(() {
            _selectedImage = image;
            _isUploading = true;
          });

          final String? url = await widget.uploadImage(image);
          if (url != null) {
            setState(() {
              _uploadedImageUrl = url;
            });
            widget.onUploadComplete?.call(url);
          } else {
            _showErrorDialog("Image upload failed. Please try again.");
          }
        } else {
          _showErrorDialog(
              "Image size exceeds 5.0 MB. Please select a smaller image.");
        }
      }
    } catch (e) {
      _showErrorDialog("An error occurred while uploading the image.");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  bool _isImageSizeValid(File image) {
    final int sizeInBytes = image.lengthSync();
    const int maxSizeInBytes = 5 * 1024 * 1024; // 5 MB
    return sizeInBytes <= maxSizeInBytes;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedImage != null)
          Image.file(
            _selectedImage!,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        if (_isUploading) const CircularProgressIndicator(),
        ElevatedButton(
          onPressed: _isUploading ? null : _pickAndUploadImage,
          child: const Text("Pick and Upload Image"),
        ),
        if (_uploadedImageUrl != null)
          Text("Image uploaded successfully! URL: $_uploadedImageUrl"),
      ],
    );
  }
}
