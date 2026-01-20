import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'AppStrings.dart';

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

        final compressedSizeInMb = (await file.length()) / (1024 * 1024);

        debugPrint(
          "Compressed file size: ${compressedSizeInMb.toStringAsFixed(2)} MB",
        );

        if (compressedSizeInMb > maxSizeInMb) {
          CommonMethods().showErrorToast(
            "Please select image less than $maxSizeInMb MB",
          );
          return null;
        }
      }
    }

    return file;
  }

  static String getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case AppStrings.errorInvalidVerificationCode:
        return AppStrings.otpInvalid;
      case AppStrings.errorSessionExpired:
        return AppStrings.otpExpired;
      default:
        return AppStrings.otpVerificationFailed;
    }
  }

  String formatPhone(String? phone) {
    if (phone == null) return "";
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length > 10
        ? digits.substring(digits.length - 10)
        : digits;
  }
  String formatPrice(num value) {
    if (value >= 1e12) {
      return '₹${(value / 1e12).toStringAsFixed(1).replaceAll('.0', '')}T';
    } else if (value >= 1e7) {
      return '₹${(value / 1e7).toStringAsFixed(1).replaceAll('.0', '')}Cr';
    } else if (value >= 1e5) {
      return '₹${(value / 1e5).toStringAsFixed(1).replaceAll('.0', '')}L';
    } else if (value >= 1e3) {
      return '₹${(value / 1e3).toStringAsFixed(1).replaceAll('.0', '')}K';
    } else {
      return '₹$value';
    }
  }


}
