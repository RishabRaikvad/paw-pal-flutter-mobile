import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

import '../../core/CommonMethods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  ValueNotifier<bool> isCheck = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GradientBackground(child: mainView()));
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            welcomeTitle(),
            SizedBox(height: 5),
            welcomeSubtitle(),
            SizedBox(height: 30),
            phoneFiled(),
            SizedBox(height: 8),
            checkBoxFiled(),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: commonTitle(
                title: AppStrings.otpInfo,
                fontSize: 12,
                color: AppColors.grey,
              ),
            ),
            commonButtonView(
              context: context,
              buttonText: AppStrings.sendVerificationCode,
              onClicked: () {
                btnClick();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget welcomeTitle() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${AppStrings.welcome} ',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: '${AppStrings.to} ',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          TextSpan(
            text: AppStrings.paw,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          TextSpan(
            text: AppStrings.pal,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget welcomeSubtitle() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${AppStrings.enterPhone} ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
            ),
          ),
          TextSpan(
            text: AppStrings.paw,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          TextSpan(
            text: "${AppStrings.pal} ",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          TextSpan(
            text: AppStrings.account,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneFiled() {
    return commonTextFieldWithLabel(
      label: AppStrings.mobileNumber,
      hint: AppStrings.enterMobileNumber,
      context: context,
      controller: phoneController,
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: commonTitle(title: AppStrings.countryCode),
      ),
      inputType: TextInputType.phone,
      maxLength: 10,
      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget checkBoxFiled() {
    return ValueListenableBuilder(
      valueListenable: isCheck,
      builder: (context, value, child) {
        return Row(
          children: [
            Checkbox(
              value: value,
              activeColor: AppColors.primaryColor,
              side: BorderSide(color: AppColors.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(5),
              ),
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryColor;
                }
                return AppColors.inputBgColor.withValues(alpha: 0.1);
              }),
              visualDensity: VisualDensity.compact,

              onChanged: (bool? newValue) {
                if (newValue != null) {
                  isCheck.value = newValue;
                }
              },
            ),
            Expanded(
              child: RichText(
                maxLines: 2,
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.agreeTo,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.termsConditions,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.andAlsoAgreeWith,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.privacyPolicy,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text: ' of ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.paw,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.pal,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void btnClick() {
    if (isValidate()) {
      context.pushNamed(Routes.otpScreen);
    }
  }

  bool isValidate() {
    final phone = phoneController.text.trim();
    final commonMethods = CommonMethods();

    if (phone.isEmpty) {
      commonMethods.showErrorToast(AppStrings.enterPhoneError);
      return false;
    }

    if (phone.length < 10) {
      commonMethods.showErrorToast(AppStrings.invalidPhoneError);
      return false;
    }

    if (!isCheck.value) {
      commonMethods.showErrorToast(AppStrings.acceptTermsError);
      return false;
    }

    return true;
  }
}
