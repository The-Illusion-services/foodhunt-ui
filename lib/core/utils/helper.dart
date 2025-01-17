import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/theme/app_colors.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

bool isImageSizeValid(File file) {
  const double maxImageSize = 5.0 * 1024 * 1024; // 7.5MB in bytes
  return file.lengthSync() <= maxImageSize;
}

void showErrorDialog(String message, BuildContext context) {
  final isIOS = Platform.isIOS;
  final dialog = isIOS
      ? CupertinoAlertDialog(
          title: Text(
            "Error",
            style: TextStyle(
                fontFamily: Font.jkSans.fontName,
                color: AppColors.bodyTextColor),
          ),
          content: Text(
            message,
            style: TextStyle(
                fontFamily: Font.jkSans.fontName,
                color: AppColors.subTitleTextColor),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: TextStyle(
                    fontFamily: Font.jkSans.fontName,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      : AlertDialog(
          title: Text(
            "Error",
            style: TextStyle(
                fontFamily: Font.jkSans.fontName,
                color: AppColors.bodyTextColor),
          ),
          content: Text(
            message,
            style: TextStyle(
                fontFamily: Font.jkSans.fontName,
                color: AppColors.subTitleTextColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: TextStyle(
                    fontFamily: Font.jkSans.fontName,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
  showDialog(context: context, builder: (_) => dialog);
}

void showInfoDialog(String title, String message, BuildContext context) {
  final isIOS = Platform.isIOS;
  final dialog = isIOS
      ? CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(
                fontFamily: Font.jkSans.fontName,
                color: AppColors.bodyTextColor),
          ),
          content: Text(
            message,
            style: TextStyle(
                fontFamily: Font.jkSans.fontName,
                color: AppColors.subTitleTextColor),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: TextStyle(
                    fontFamily: Font.jkSans.fontName,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      : AlertDialog(
          title: Text(
            title,
            style: TextStyle(
                fontFamily: Font.jkSans.fontName,
                color: AppColors.bodyTextColor),
          ),
          content: Text(
            message,
            style: TextStyle(
                fontFamily: Font.jkSans.fontName,
                color: AppColors.subTitleTextColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: TextStyle(
                    fontFamily: Font.jkSans.fontName,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
  showDialog(context: context, builder: (_) => dialog);
}

Future<File> urlToFile(String imageUrl) async {
  try {
    // Get the temporary directory of the device
    final tempDir = await getTemporaryDirectory();

    // Create a unique file name for the downloaded file
    final fileName = imageUrl.split('/').last;

    // Define the file path
    final filePath = '${tempDir.path}/$fileName';

    // Download the file data
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      // Save the file data to the temporary file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to download image');
    }
  } catch (e) {
    throw Exception('Error while converting URL to File: $e');
  }
}
