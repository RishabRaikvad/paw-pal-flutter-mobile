import 'package:flutter/material.dart';

import '../core/AppColors.dart';

Widget commonButtonView({
  required BuildContext context,
  required String buttonText,
  required VoidCallback onClicked,
  bool isLoading = false,
  Color? bgColor,
}) {
  return ElevatedButton(
    onPressed: () {
      if (isLoading) return;
      onClicked();
    },
    style: ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, 50),
      backgroundColor: bgColor ?? AppColors.primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      elevation: 0,
    ),
    child: isLoading
        ? SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    )
        : Text(
      buttonText,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
Widget commonTitle({
  required String title,
  double fontSize = 15,
  FontWeight fontWeight = FontWeight.w500,
  TextAlign textAlign = TextAlign.center,
  Color color = AppColors.black,
  TextStyle? style,
  TextOverflow? overFlow,
  int? maxLines,
  bool isUnderLine = false,
  bool lineThrough = false,
}) {
  return Text(
    title,
    style:
    style ??
        TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          decoration: isUnderLine
              ? TextDecoration.underline
              : lineThrough
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          decorationColor: color,
        ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overFlow,
  );
}