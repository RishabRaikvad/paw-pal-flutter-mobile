import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/utils/ui_helper.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

import '../core/AppImages.dart';

class DialogUtils {
  static final DialogUtils _instance = DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static Future<T?> openBottomSheetDialog<T>({
    required BuildContext context,
    required Widget contentWidget,
    bool isScrollControlled = false,
    bool isDismissible = false,
    Color backgroundColor = AppColors.white,
    double horizontalPadding = 12,
    bool useFlexible = true,
  }) {
    return showModalBottomSheet<T>(
      isScrollControlled: isScrollControlled,
      useSafeArea: true,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 10),
              if (useFlexible)
                Flexible(child: contentWidget)
              else
                contentWidget,
            ],
          ),
        );
      },
    );
  }

  static void logoutDialog({
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: UIHelper.screenHeight(context) * 0.8,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppImages.icDialogLogout,
                        height: 70,
                        width: 70,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: commonTitle(
                        title: AppStrings.logoutTitle,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: commonTitle(
                        title: AppStrings.logoutSubtitle,
                        fontSize: 13,
                        color: AppColors.grey,
                      ),
                    ),
                    commonTitle(
                      title: AppStrings.noteTitle,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    bulletText(AppStrings.logoutBullet1),
                    bulletText(AppStrings.logoutBullet2),
                    bulletText(AppStrings.logoutBullet3),
                    const SizedBox(height: 5),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: commonOutLineButtonView(
                            context: context,
                            buttonText: AppStrings.stayLoggedIn,
                            onClicked: () {
                              context.pop();
                            },
                            fontSize: 12,
                          ),
                        ),
                        Flexible(
                          child: commonButtonView(
                            context: context,
                            buttonText: AppStrings.yesLogout,
                            onClicked: () {
                              CommonMethods.firebaseLogOut(context);
                            },
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  static void adoptionRequestDialog({
    required BuildContext context,
  }) {
    showDialog(
     barrierDismissible: false,
      context: context,
      barrierColor: AppColors.inputBgColor.withValues(alpha: 0.01), // optional overlay
      builder: (context) {
        return PopScope(
          canPop: false,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Dialog(
              backgroundColor: AppColors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: UIHelper.screenHeight(context) * 0.8,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AppImages.icViewAdoptionRequest,
                            height: 70,
                            width: 70,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: commonTitle(
                            title: "Request Sent Successfully",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: commonTitle(
                            title:
                            "Your request has been sent successfully. The pet owner will review it soon.",
                            fontSize: 13,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        commonDottedLine(),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.grey,
                              fontWeight: FontWeight.w500,
                              fontFamily: Constant.fontFamily,
                            ),
                            children: [
                              TextSpan(text: "You can track your requests form   "),
                              TextSpan(
                                text: "“My Requests”",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Constant.fontFamily,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        commonButtonView(
                          context: context,
                          buttonText: "View Requests",
                          onClicked: () {
                            context.goNamed(Routes.requestScreen);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
