import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class CommonMethods {
  void showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      // or Toast.LENGTH_LONG
      gravity: ToastGravity.BOTTOM,
      // Position: BOTTOM, CENTER, TOP
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      // or Toast.LENGTH_LONG
      gravity: ToastGravity.BOTTOM,
      // Position: BOTTOM, CENTER, TOP
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickAndCompressImage({
    required BuildContext context,
    ImageSource source = ImageSource.gallery,
    double maxSizeInMb = 1.0,
    int quality = 75,
  }) async {
    if (!context.mounted) return null;

    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (pickedFile == null) return null;

    File file = File(pickedFile.path);

    final fileSizeInMb = (await file.length()) / (1024 * 1024);
    debugPrint("Picked file size: ${fileSizeInMb.toStringAsFixed(2)} MB");

    if (fileSizeInMb > maxSizeInMb) {
      final targetPath =
          "${file.parent.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg";

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
      );

      if (compressedFile != null) {
        file = File(compressedFile.path);

        final compressedSizeInMb =
            (await file.length()) / (1024 * 1024);

        debugPrint(
          "Compressed file size: ${compressedSizeInMb.toStringAsFixed(2)} MB",
        );

        if (compressedSizeInMb > maxSizeInMb) {
          CommonMethods()
              .showErrorToast("Please select image less than $maxSizeInMb MB");
          return null;
        }
      }
    }

    return file;
  }
}
