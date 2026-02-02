import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';

import '../core/AppColors.dart';

final nameRegEx = RegExp(r"^[A-Za-z][A-Za-z\s'.-]{1,29}$");
final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

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
  int maxLines = 1,
  bool readOnly = false,
  VoidCallback? onClick,
  int? maxLength,
  List<TextInputFormatter>? inputFormatter,
  TextInputType inputType = TextInputType.text,
  TextInputAction textInputAction = TextInputAction.next,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      commonTitle(title: label, fontSize: 14, color: AppColors.grey),
      const SizedBox(height: 8),
      TextField(
        onTap: onClick,
        readOnly: readOnly,
        maxLines: maxLines,
        maxLength: maxLength,
        controller: controller,
        keyboardType: inputType,
        cursorColor: AppColors.primaryColor,
        inputFormatters: inputFormatter,
        style: TextStyle(
          color: AppColors.plashHolderColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        textInputAction: textInputAction,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 7),
          fillColor: AppColors.inputBgColor.withValues(alpha: 0.1),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hint,
          filled: true,
          hintStyle: TextStyle(
            color: AppColors.plashHolderColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
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

Widget commonBackWithHeader({
  required BuildContext context,
  String? title,
  bool isShowTitle = false,
}) {
  return GestureDetector(
    onTap: () {
      context.pop();
    },
    child: Row(
      children: [
        Icon(
          Icons.arrow_back,
          size: 22,
        ),

        if (isShowTitle)
          Expanded(child: commonTitle(title: title ?? "",fontSize: 16,fontWeight: FontWeight.w600)),
      ],
    ),
  );
}


Widget commonOutLineButtonView({
  required BuildContext context,
  required String buttonText,
  required VoidCallback onClicked,
  bool isLoading = false,
  Color? bgColor,
}) {
  return OutlinedButton(
    onPressed: () {
      if (isLoading) return;
      onClicked();
    },
    style: ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, 50),
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
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
        color: AppColors.black,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget uploadImageView({
  required BuildContext context,
  required ValueNotifier<File?> uploadedImage,
  required String image,
  double width = 100,
  double height = 100,
  double radius = 14,
  BoxFit boxFit = BoxFit.contain,
  Alignment alignment = Alignment.topCenter,
}) {
  return GestureDetector(
    onTap: () async {
      final image = await CommonMethods.pickAndCompressImage(context: context);
      if (image != null) {
        uploadedImage.value = image;
      }
    },
    child: ValueListenableBuilder(
      valueListenable: uploadedImage,
      builder: (context, img, child) {
        return img != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.file(
            img,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        )
            : SvgPicture.asset(
          image,
          fit: boxFit,
          alignment: alignment,
          width: width,
          height: height,
        );
      },
    ),
  );
}

Widget commonDottedLine() {
  return DottedLine(
    dashColor: AppColors.dividerColor,
    lineThickness: 2,
    dashLength: 5, // length of dash
    dashGapLength: 5,
  );
}

Widget commonNetworkImage({
  required String imageUrl,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  double borderRadius = 0,
  String? placeholderImage,
  String? errorImage,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          SvgPicture.asset(
            AppImages.icAppIconPlaceholder,
            width: width,
            height: height,
            fit: BoxFit.contain,
          ),
      errorWidget: (context, url, error) =>
          SvgPicture.asset(
            AppImages.icAppIconPlaceholder,
            width: width,
            height: height,
            fit: BoxFit.contain,
          ),
    ),
  );
}

Widget commonSearchBar({
  required TextEditingController controller,
  required ValueChanged<String?>? onSearchChange,
  required Function(String) onSearch,
}) {
  return TextField(
    controller: controller,
    onChanged: onSearchChange,
    onSubmitted: onSearch,
    style: TextStyle(
      color: AppColors.grey,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    decoration: InputDecoration(
      fillColor: AppColors.white,
      filled: true,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SvgPicture.asset(AppImages.icSearch),
      ),
      hintText: "Search pets, products & care...",
      hintStyle: TextStyle(
        color: AppColors.grey,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
    ),
  );
}

Widget commonPetCareVideoCard(int index) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonNetworkImage(
            imageUrl: "https://loremflickr.com/500/500/pet,grooming?lock=${index +
                1}", width: double.infinity, height: 200,borderRadius: 10),
        SizedBox(height: 10),
        Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 22, backgroundColor: AppColors.primaryColor),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonTitle(
                    title: "Bird Pet Parakeet Colorful Singing Companion",
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    overFlow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      commonTitle(
                        title: "Feathered Friend",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey,
                      ),
                      CircleAvatar(backgroundColor: AppColors.grey, radius: 3),
                      commonTitle(
                        title: "5:12 min",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget commonSeeAllText({required VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: commonTitle(
      title: "See all",
      isUnderLine: true,
      color: AppColors.primaryColor,
    ),
  );
}

Widget commonProductCard(int index) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: Column(
        children: [
          SizedBox(
            height: 145,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: commonNetworkImage(
                        imageUrl: "https://loremflickr.com/500/500/pet,grooming?lock=${index +
                            1}", borderRadius: 10),
                  ),
                ),

                // SVG LOCKED TO IMAGE BOTTOM
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -20,
                  child: SvgPicture.asset(AppImages.icShop),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: commonTitle(
                    title: "Pedigree Adult dog food - Chicken and Vegetables",
                    fontSize: 13,
                    maxLines: 2,
                    overFlow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(width: 6),

                Icon(Icons.star, color: AppColors.startColor, size: 14),

                const SizedBox(width: 3),

                commonTitle(
                  title: "4.2",
                  fontSize: 13,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),

          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: commonTitle(
                    title: "400 gm",
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                ),

                commonTitle(
                  title: CommonMethods().formatPrice(5000),
                  fontSize: 14,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget commonPetCard(int index) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AspectRatio(
                  aspectRatio: 1.1,
                  child: commonNetworkImage(
                    imageUrl: "https://placedog.net/500/500?id=${index + 1}",
                    borderRadius: 20,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: -18,
                  left: 0,
                  child: SvgPicture.asset(AppImages.icAdoptMe),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    spacing: 3,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonTitle(
                        title: "Reilly",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overFlow: TextOverflow.ellipsis,
                      ),
                      commonTitle(
                        title: "Siberian Husky",
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.grey,
                        maxLines: 1,
                        overFlow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 18),
                commonTitle(
                  title: CommonMethods().formatPrice(5000),
                  fontSize: 14,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget sectionHeaderWithSeeAll({
  required String title,
  required VoidCallback onTap,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      commonTitle(title: title, fontWeight: FontWeight.w600, fontSize: 16),
      commonSeeAllText(onTap: onTap),
    ],
  );
}
