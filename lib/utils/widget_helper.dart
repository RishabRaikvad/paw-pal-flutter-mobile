import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
        fontSize: 16,
        fontWeight: FontWeight.w500,
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

Widget commonTextFieldWithLabel({
  required String label,
  required String hint,
  required BuildContext context,
  TextEditingController? controller,
  Widget? suffixIcon,
  Widget? prefixIcon,
  int? maxLines,
  bool readOnly = false,
  VoidCallback? onClick,
  int? maxLength,
  List<TextInputFormatter>? inputFormatter,
  TextInputType inputType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      commonTitle(title: label,fontSize: 14,color: AppColors.grey),
      const SizedBox(height: 8),
      TextField(
        onTap: onClick,
        readOnly: readOnly,
        maxLines: maxLines,
        maxLength:maxLength ,
        controller: controller,
        keyboardType: inputType,
        cursorColor: AppColors.primaryColor,
        inputFormatters: inputFormatter,
        style: TextStyle(color: AppColors.plashHolderColor,fontSize: 15,fontWeight: FontWeight.w500),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 7),
          fillColor: AppColors.inputBgColor.withValues(alpha: 0.1),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hint,
          filled: true,
          hintStyle: TextStyle(color: AppColors.plashHolderColor,fontSize: 15,fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    ],
  );
}