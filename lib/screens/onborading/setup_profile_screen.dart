import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final ValueNotifier<File?> profileImageNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GradientBackground(child: mainView()));
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 56),
            commonTitle(
              title: "Let’s Set Up Your Profile",
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
            SizedBox(height: 8),
            commonTitle(
              title:
                  "Tell us a little about yourself to personalize your\nPawPal experience.",
              color: AppColors.grey,
              fontSize: 14,
              textAlign: TextAlign.start,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 45),
                    uploadProfileView(),
                    SizedBox(height: 15),
                    buildFormWidget(),
                    SizedBox(height: 30),
                    commonButtonView(
                      context: context,
                      buttonText: "buttonText",
                      onClicked: () {},
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget uploadProfileView() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final image = await CommonMethods.pickAndCompressImage(
                context: context,
              );

              if (image != null) {
                profileImageNotifier.value = image;
              }
            },
            child: ValueListenableBuilder<File?>(
              valueListenable: profileImageNotifier,
              builder: (context, image, _) {
                return image != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(image),
                      )
                    : SvgPicture.asset(AppImages.icUploadProfile);
              },
            ),
          ),

          SizedBox(height: 10),
          commonTitle(title: "Upload Profile Photo", color: AppColors.grey),
        ],
      ),
    );
  }

  Widget buildFormWidget() {
    return Column(
      spacing: 18,
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: commonTextFieldWithLabel(
                label: "First Name",
                hint: "Enter First Name",
                context: context,
                maxLines: 1,
              ),
            ),
            Expanded(
              child: commonTextFieldWithLabel(
                label: "Last Name",
                hint: "Enter Last Name",
                context: context,
                maxLines: 1,
              ),
            ),
          ],
        ),
        commonTextFieldWithLabel(
          label: "Email",
          hint: "Enter Email Address",
          context: context,
          inputType: TextInputType.emailAddress,
        ),
        commonTextFieldWithLabel(
          label: "Email",
          hint: "Enter Email Address",
          context: context,
          inputType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
        ),
        commonTextFieldWithLabel(
          label: AppStrings.mobileNumber,
          hint: AppStrings.enterMobileNumber,
          context: context,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: commonTitle(title: AppStrings.countryCode),
          ),
          readOnly: true,
          inputType: TextInputType.phone,
          maxLength: 10,
          inputFormatter: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }
}
