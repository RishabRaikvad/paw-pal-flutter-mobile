import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/bloc/profileBloc/profile_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';


class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  late ProfileCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<ProfileCubit>();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      cubit.mobileController.text = CommonMethods().formatPhone(
        user.phoneNumber,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GradientBackground(child: mainView()));
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
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
                onClicked: () {
                  if (isAllFiledValidated()) {
                    context.pushNamed(Routes.addressScreen);
                  }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
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
                cubit.profileImageNotifier.value = image;
              }
            },
            child: ValueListenableBuilder<File?>(
              valueListenable: cubit.profileImageNotifier,
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
                controller: cubit.firstNameController,
              ),
            ),
            Expanded(
              child: commonTextFieldWithLabel(
                label: AppStrings.lastName,
                hint: AppStrings.enterLastName,
                context: context,
                maxLines: 1,
                controller: cubit.lastNameController,
              ),
            ),
          ],
        ),
        commonTextFieldWithLabel(
          label: AppStrings.email,
          hint: AppStrings.enterEmailAddress,
          context: context,
          inputType: TextInputType.emailAddress,
          controller: cubit.emailController,
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
          controller: cubit.mobileController,
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
      onTap: () => cubit.genderNotifier.value = value,
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
      valueListenable: cubit.genderNotifier,
      builder: (context, selectedGender, _) {
        return RadioGroup<Gender>(
          groupValue: selectedGender,
          onChanged: (value) {
            cubit.genderNotifier.value = value;
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

  bool isAllFiledValidated() {
    final name = cubit.firstNameController.text.trim();
    final email = cubit.emailController.text.trim();
    final lastName = cubit.lastNameController.text.trim();
    final commonMethod = CommonMethods();
    if (name.isEmpty) {
      commonMethod.showErrorToast("Please Enter Name");
      return false;
    } else if (!nameRegEx.hasMatch(name)) {
      commonMethod.showErrorToast("Please Enter Valid Name");
      return false;
    } else if (lastName.isEmpty) {
      commonMethod.showErrorToast("Please Enter Last Name");
      return false;
    } else if (!nameRegEx.hasMatch(lastName)) {
      commonMethod.showErrorToast("Please Enter Valid Last Name");
      return false;
    } else if (email.isEmpty) {
      commonMethod.showErrorToast("Please Enter Email");
      return false;
    } else if (!emailRegex.hasMatch(email)) {
      commonMethod.showErrorToast("Please Enter Valid Email");
      return false;
    }
    return true;
  }
}
