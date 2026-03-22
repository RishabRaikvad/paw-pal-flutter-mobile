import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:paw_pal_mobile/model/order_model.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return digits.length > 10 ? digits.substring(digits.length - 10) : digits;
  }

  String formatPrice(num value) {
    String removeTrailingZeros(num val) {
      String str = val.toStringAsFixed(2);
      str = str.replaceAll(RegExp(r'\.?0+$'), '');
      return str;
    }

    if (value >= 1e12) {
      return '₹${removeTrailingZeros(value / 1e12)}T';
    } else if (value >= 1e7) {
      return '₹${removeTrailingZeros(value / 1e7)}Cr';
    } else if (value >= 1e5) {
      return '₹${removeTrailingZeros(value / 1e5)}L';
    } else if (value >= 1e3) {
      return '₹${removeTrailingZeros(value / 1e3)}K';
    } else {
      return '₹$value';
    }
  }

  static Future<void> openYoutube(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open YouTube';
    }
  }

  static Future<void> call(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open dialer';
    }
  }

  static User? getCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint("user not found");
      return null;
    }
    return user;
  }

  static Future<void> firebaseLogOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      context.goNamed(Routes.loginScreen);
    }
  }

  static String formatPetAge({required int years, required int months}) {
    int totalMonths = (years * 12) + months;

    if (totalMonths == 0) {
      return "Age not set";
    }

    // If less than 12 months → show only months
    if (totalMonths < 12) {
      return "$totalMonths month${totalMonths > 1 ? "s" : ""}";
    }

    int finalYears = totalMonths ~/ 12;
    int finalMonths = totalMonths % 12;

    // If exact year → show only years
    if (finalMonths == 0) {
      return "$finalYears year${finalYears > 1 ? "s" : ""}";
    }

    // Show years + months
    return "$finalYears year${finalYears > 1 ? "s" : ""} $finalMonths month${finalMonths > 1 ? "s" : ""}";
  }

  static List<String> getDaysList() {
    return [
      AppStrings.sunday,
      AppStrings.monday,
      AppStrings.tuesday,
      AppStrings.wednesday,
      AppStrings.thursday,
      AppStrings.friday,
      AppStrings.saturday,
    ];
  }

  String formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }

  String getOrderStatusWiseTitle(OrderStatus status) {
    if (status == OrderStatus.delivered) {
      return "Delivered Successfully !";
    } else if (status == OrderStatus.cancel) {
      return "Your Order Cancelled";
    }
    return "Preparing Your Order";
  }


}
