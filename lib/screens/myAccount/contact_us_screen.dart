import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
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
              const SizedBox(height: 20),
              commonBackWithHeader(
                context: context,
                title: AppStrings.contactUs,
                isShowTitle: true,
              ),
              const SizedBox(height: 20),
              commonTitle(
                title: "Get in Touch",
                fontSize: 22,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 4),
              commonTitle(
                title:
                    "We’re here to help. Contact us anytime with your questions or concerns.",
                fontSize: 16,
                textAlign: TextAlign.start,
                color: AppColors.grey,
              ),
              const SizedBox(height: 20),
              contactUsView(
                icon: AppImages.icGeneral,
                title: "General Inquiries",
                subtitle:
                    "Have questions about services, your account or general info? We’re happy t help.",
                contactTitle: "Email:",
                contact: "info@pawpal.com",
                onTap: (){
                  CommonMethods.openMail("info@pawpal.com");
                }
              ),
              const SizedBox(height: 20),
              contactUsView(
                  icon: AppImages.icTech,
                  title: "Technical Support",
                  subtitle:
                  "Facing a bug technical issue? Contact our support team for quick assistance.",
                  contactTitle: "Email:",
                  contact: "support@pawpal.com",
                  onTap: (){
                    CommonMethods.openMail("support@pawpal.com");
                  }
              ),
              const SizedBox(height: 20),
              contactUsView(
                  icon: AppImages.icTalk,
                  title: "Talk to Us",
                  subtitle:
                  "Need help with your account or services? Give us a call anytime.",
                  contactTitle: "Call:",
                  contact: "+91 9898394874",
                  onTap: (){
                    CommonMethods.call("+91 9898394874");
                  },
                isUnderLine: false
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget contactUsView({
    required String icon,
    required String title,
    required String subtitle,
    required String contactTitle,
    required String contact,
    bool isUnderLine = true,
    required VoidCallback onTap
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.inputBgColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(icon),
            const SizedBox(height: 10),
            commonTitle(
              title: title,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 3),
            commonTitle(title: subtitle, color: AppColors.grey, fontSize: 14,textAlign: TextAlign.start),
            const SizedBox(height: 8),
            Divider(color: AppColors.grey.withValues(alpha: 0.8)),
            const SizedBox(height: 8),
            commonTitle(title: contactTitle, fontSize: 14),
            const SizedBox(height: 3),
            GestureDetector(
              onTap: onTap,
              child: commonTitle(
                title: contact,
                color: AppColors.primaryColor,
                fontSize: 16,
                isUnderLine: isUnderLine,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
