import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

import '../../core/AppColors.dart';
import '../../utils/commonWidget/gradient_background.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(child: mainView()),
    );
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            commonBackWithHeader(
              context: context,
              title: "My Account",
              isShowTitle: true,
            ),
            Flexible(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: const SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: Align(
                      alignment: Alignment.center,
                      child: profileView(),
                    ),
                  ),
                  SliverToBoxAdapter(child: const SizedBox(height: 30)),
                  SliverToBoxAdapter(child: accountSettingView()),
                  SliverToBoxAdapter(child: const SizedBox(height: 20)),
                  SliverToBoxAdapter(child: supportCenterView()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade200,
          child: ClipOval(
            child: commonNetworkImage(
              imageUrl: "https://i.pravatar.cc/150?img=3",
            ),
          ),
        ),
        SizedBox(height: 5),
        commonTitle(
          title: "Rishabh Raikvad",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        commonTitle(
          title: "rishabh@gmail.com",
          fontSize: 13,
          color: AppColors.grey,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget accountSettingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Account Settings",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: buildCardView(
                icon: AppImages.icAccountInfo,
                title: "Account Information",
              ),
            ),
            Expanded(
              child: buildCardView(
                icon: AppImages.icManagePaw,
                title: "Manage Paws",
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: buildCardView(
                icon: AppImages.icOrderHistory,
                title: "Order History",
              ),
            ),
            Expanded(
              child: buildCardView(
                icon: AppImages.icAddressDetail,
                title: "Address Detail",
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget supportCenterView(){
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(title: "Support Center",fontSize: 16,fontWeight: FontWeight.w600),
        buildSupportCenterTitleView(icon: AppImages.icAddressDetail, title: "Frequently Asked Questions"),
        buildSupportCenterTitleView(icon: AppImages.icAddressDetail, title: "Terms & Conditions"),
        buildSupportCenterTitleView(icon: AppImages.icAddressDetail, title: "Privacy Policy"),
        buildSupportCenterTitleView(icon: AppImages.icAddressDetail, title: "Contact Us"),
        buildSupportCenterTitleView(icon: AppImages.icAddressDetail, title: "Logout"),
        const SizedBox(height: 10,),
      ],
    );
  }
  
  Widget buildCardView({required String icon, required String title}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.inputBgColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RepaintBoundary(child: SvgPicture.asset(icon)),
            commonTitle(
              title: title,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              maxLines: 1,
              overFlow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  } 
  
  Widget buildSupportCenterTitleView({required String icon,required String title}){
    return Row(
      spacing: 10,
      children: [
        RepaintBoundary(child: SvgPicture.asset(icon),),
        commonTitle(title: title,fontWeight: FontWeight.w600,fontSize: 14)
      ],
    );
  }
}
