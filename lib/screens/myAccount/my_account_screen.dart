import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/bloc/myAccountBloc/my_account_cubit.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/utils/dialog_utils.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/AppColors.dart';
import '../../utils/commonWidget/gradient_background.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late MyAccountCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<MyAccountCubit>();
    cubit.loadMyAccount();
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            commonBackWithHeader(
              context: context,
              title: AppStrings.myAccount,
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
    return BlocBuilder<MyAccountCubit, MyAccountState>(
      builder: (context, state) {
        if (state is ErrorMyAccountState) {
          return commonTitle(title: state.error);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.grey.shade200,
              child: ClipOval(
                child: commonNetworkImage(imageUrl: cubit.getProfileImage()),
              ),
            ),
            SizedBox(height: 5),
            commonTitle(
              title: cubit.getFullName(),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            commonTitle(
              title: cubit.getEmail(),
              fontSize: 13,
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),
          ],
        );
      },
    );
  }

  Widget accountSettingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: AppStrings.accountSettings,
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
                title: AppStrings.accountInformation,
                onTap: () {
                  context.pushNamed(Routes.accountInfoScreen);
                },
              ),
            ),
            Expanded(
              child: buildCardView(
                icon: AppImages.icManagePaw,
                title: AppStrings.managePaws,
                onTap: () {},
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
                title: AppStrings.orderHistory,
                onTap: () {},
              ),
            ),
            Expanded(
              child: buildCardView(
                icon: AppImages.icAddressDetail,
                title: AppStrings.addressDetail,
                onTap: () {
                  context.pushNamed(Routes.addressDetailScreen);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget supportCenterView() {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: AppStrings.supportCenter,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        buildSupportCenterTitleView(
          icon: AppImages.icFaq,
          title: AppStrings.faq,
          onTap: () {},
        ),
        buildSupportCenterTitleView(
          icon: AppImages.icTerms,
          title: AppStrings.termsConditions,
          onTap: () {},
        ),
        buildSupportCenterTitleView(
          icon: AppImages.icPrivacy,
          title: AppStrings.privacyPolicy,
          onTap: () {},
        ),
        buildSupportCenterTitleView(
          icon: AppImages.icContactUs,
          title: AppStrings.contactUs,
          onTap: () {},
        ),
        buildSupportCenterTitleView(
          icon: AppImages.icLogout,
          title: AppStrings.logout,
          onTap: () {
            DialogUtils.logoutDialog(onTap: () {}, context: context);
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildCardView({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkResponse(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  Widget buildSupportCenterTitleView({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkResponse(
      onTap: onTap,
      child: Row(
        spacing: 10,
        children: [
          RepaintBoundary(child: SvgPicture.asset(icon)),
          commonTitle(title: title, fontWeight: FontWeight.w600, fontSize: 14),
        ],
      ),
    );
  }

  Widget profileShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: CircleAvatar(
            radius: 45,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 8),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 16,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 13,
            width: 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }
}
