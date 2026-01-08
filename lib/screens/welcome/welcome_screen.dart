import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/utils/ui_helper.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImages.imgWelcome,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: UIHelper.screenHeight(context) * 0.18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${AppStrings.welcome}\n',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${AppStrings.to} ',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                      TextSpan(
                        text: AppStrings.paw,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: AppStrings.pal,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                commonTitle(
                  title: AppStrings.welcomeSubtitle,
                  fontSize: 12,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),

                const SizedBox(height: 24),
                swipeButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget swipeButton() {
    return SwipeButton.expand(
      thumb: SvgPicture.asset(AppImages.icPaw),
      thumbPadding: EdgeInsets.all(3),
      activeThumbColor: AppColors.primaryColor,
      onSwipe: () {},
      child: commonTitle(title: "Swipe to Continue"),
    );
  }
}
