import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final ValueNotifier<File?> profileImageNotifier = ValueNotifier(null);
  final ValueNotifier<Gender?> genderNotifier =
  ValueNotifier<Gender?>(Gender.male);


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
              title: AppStrings.setupProfileTitle,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
            SizedBox(height: 8),
            commonTitle(
              title: AppStrings.setupProfileSubtitle,
              color: AppColors.grey,
              fontSize: 14,
              textAlign: TextAlign.start,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 45),
                    uploadProfileView(),
                    SizedBox(height: 18),
                    buildFormWidget(),
                    SizedBox(height: 18),
                    commonTitle(
                      title: AppStrings.gender,
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                    genderRadioButtons(),
                    SizedBox(height: 30),
                    commonButtonView(
                      context: context,
                      buttonText: AppStrings.continueText,
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
          commonTitle(
            title: AppStrings.uploadProfilePhoto,
            color: AppColors.grey,
          ),
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
                label: AppStrings.firstName,
                hint: AppStrings.enterFirstName,
                context: context,
                maxLines: 1,
              ),
            ),
            Expanded(
              child: commonTextFieldWithLabel(
                label: AppStrings.lastName,
                hint: AppStrings.enterLastName,
                context: context,
                maxLines: 1,
              ),
            ),
          ],
        ),
        commonTextFieldWithLabel(
          label: AppStrings.email,
          hint: AppStrings.enterEmailAddress,
          context: context,
          inputType: TextInputType.emailAddress,
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

  Widget _genderTile({
    required String title,
    required Gender value,
    required Gender? selectedGender,
  }) {
    return GestureDetector(
      onTap: () => genderNotifier.value = value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<Gender>(
            value: value,
            fillColor: WidgetStateProperty.resolveWith(
              (states) => AppColors.primaryColor,
            ),
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (!states.contains(WidgetState.selected)) {
                return AppColors.plashHolderColor.withValues(alpha: 0.1);
              }
              return AppColors.primaryColor.withValues(alpha: 0.1);
            }),
          ),
          commonTitle(title: title, fontSize: 14, color: AppColors.grey),
        ],
      ),
    );
  }

  Widget genderRadioButtons() {
    return ValueListenableBuilder<Gender?>(
      valueListenable: genderNotifier,
      builder: (context, selectedGender, _) {
        return RadioGroup<Gender>(
          groupValue: selectedGender,
          onChanged: (value) {
            genderNotifier.value = value;
          },
          child: Row(
            children: [
              _genderTile(
                title: AppStrings.male,
                value: Gender.male,
                selectedGender: selectedGender,
              ),
              const SizedBox(width: 16),
              _genderTile(
                title: AppStrings.female,
                value: Gender.female,
                selectedGender: selectedGender,
              ),
            ],
          ),
        );
      },
    );
  }
}
