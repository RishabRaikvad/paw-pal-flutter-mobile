import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/bloc/adoptionRequestBloc/adoption_request_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/dialog_utils.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

import '../../core/AppImages.dart';
import '../../core/AppStrings.dart';
import '../../model/adoption_request_model.dart';
import '../../utils/ui_helper.dart';

class MyRequestScreen extends StatefulWidget {
  const MyRequestScreen({super.key});

  @override
  State<MyRequestScreen> createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  late AdoptionRequestCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<AdoptionRequestCubit>();
    cubit.getAdoptionRequest();
  }
  @override
  void dispose() {
    cubit.resetData();
    super.dispose();
  }
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
            const SizedBox(height: 20),
            commonBackWithHeader(
              context: context,
              title: "My Requests",
              isShowTitle: true,
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed(Routes.dashBoardScreen);
                }
              },
            ),
            const SizedBox(height: 20),
            Flexible(
              child: BlocBuilder<AdoptionRequestCubit, AdoptionRequestState>(
                builder: (context, state) {
                  if (state is AdoptionRequestLoadingState) {
                    return requestShimmerView();
                  } else if (state is AdoptionRequestErrorState) {
                    return Center(child: commonTitle(title: state.error));
                  }
                  return commonRefreshIndicator(
                    onRefresh: cubit.getAdoptionRequest,
                    child: CustomScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(child: filterView()),
                        SliverToBoxAdapter(child: const SizedBox(height: 15)),
                        cubit.filterAdoptionList.isNotEmpty
                            ? requestList()
                            : SliverToBoxAdapter(
                                child: Center(
                                  child: commonTitle(title: "No Request Found"),
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverList requestList() {
    final user = CommonMethods.getCurrentUser();
    if (user == null) {
      return SliverList(delegate: SliverChildListDelegate([]));
    }

    final list = cubit.filterAdoptionList;

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final request = list[index];
        final isSentByMe = request.petOwnerId == user.uid;
        final displayName = request.fullName;
        final displayImage = request.petBuyerProfileImage;
        return buildRequestView(
          isSentByMe: isSentByMe,
          profileImage: displayImage,
          userName: displayName,
          date: request.createdAt,
          petName: request.petName,
          model: request,
        );
      }, childCount: list.length),
    );
  }

  Widget buildRequestView({
    required bool isSentByMe,
    required String profileImage,
    required String userName,
    required DateTime date,
    required String petName,
    required AdoptionRequestModel model,
  }) {
    return GestureDetector(
      onTap: (){
        viewDetailBottomSheet(model, isSentByMe);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.inputBgColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            requestStatusView(model.status),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: commonNetworkImage(
                          imageUrl: profileImage,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 3,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: commonTitle(
                                    title: userName,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    maxLines: 1,
                                    overFlow: TextOverflow.ellipsis,
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: AppColors.primaryColor,
                                  radius: 3,
                                ),
                                commonTitle(
                                  title: cubit.timeAgo(date),
                                  fontSize: 12,
                                  color: AppColors.grey,
                                ),
                              ],
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                  fontFamily: Constant.fontFamily,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: !isSentByMe
                                        ? "You requested to adopt  "
                                        : "Interested in adopting  ",
                                  ),
                                  TextSpan(
                                    text: petName,
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  commonDottedLine(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: commonTitle(
                          title: cubit.getRequestTitle(model.status, isSentByMe),
                          fontSize: 12,
                          color: cubit.getRequestStatusColor(model.status),
                          textAlign: TextAlign.start,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: cubit.getRequestStatusColor(model.status),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: myRequestButtonTitle(model, isSentByMe),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myRequestButtonTitle(AdoptionRequestModel model, bool isSentByMe) {
    if (model.status == AdoptionStatus.pending) {
      return InkResponse(
        onTap: () {
          viewDetailBottomSheet(model, isSentByMe);
        },
        child: commonTitle(
          title: !isSentByMe ? "View Details" : "Review Request",
          color: AppColors.white,
          fontSize: 12,
        ),
      );
    } else if (model.status == AdoptionStatus.approved) {
      if (isSentByMe) {
        return commonTitle(
          title: "Collect Payment",
          color: AppColors.white,
          fontSize: 12,
        );
      }
    }
    return InkResponse(
      onTap: () {
        if (isSentByMe) {
          viewDetailBottomSheet(model, isSentByMe);
        } else {
          context.goNamed(Routes.dashBoardScreen);
        }
      },
      child: commonTitle(
        title: !isSentByMe ? "Find Another Pet" : "View Details",
        color: AppColors.white,
        fontSize: 12,
      ),
    );
  }

  Widget requestStatusView(AdoptionStatus status) {
    return Positioned(
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: cubit.getRequestStatusColor(status),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: commonTitle(
          title: cubit.getRequestStatusTitle(status),
          color: AppColors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget acceptOrRejectView({
    required VoidCallback onAccept,
    required VoidCallback onReject,
  }) {
    return Row(
      spacing: 10,
      children: [
        Flexible(
          child: commonOutLineButtonView(
            context: context,
            buttonText: "Reject Request",
            onClicked: onReject,
            fontSize: 13,
          ),
        ),
        Flexible(
          child: commonButtonView(
            context: context,
            buttonText: "Accept Request",
            onClicked: onAccept,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget viewDetailsView(VoidCallback onClick) {
    return commonButtonView(
      context: context,
      buttonText: "View Details",
      onClicked: onClick,
    );
  }

  Widget requestShimmerView() {
    return CustomScrollView(slivers: [shimmerListSliver(height: 100)]);
  }

  Widget filterView() {
    final selected = cubit.selectedFilter;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),

      child: Row(
        children: [
          buildFilterButton(context, "All", null, selected == null),
          buildFilterButton(
            context,
            "Pending",
            AdoptionStatus.pending,
            selected == AdoptionStatus.pending,
          ),
          buildFilterButton(
            context,
            "Approved",
            AdoptionStatus.approved,
            selected == AdoptionStatus.approved,
          ),
          buildFilterButton(
            context,
            "Reject",
            AdoptionStatus.rejected,
            selected == AdoptionStatus.rejected,
          ),
        ],
      ),
    );
  }

  Widget buildFilterButton(
    BuildContext context,
    String title,
    AdoptionStatus? status,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        cubit.onFilterChange(status);
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.dividerColor,
            width: 1.2,
          ),
        ),
        child: commonTitle(
          title: title,
          color: isSelected ? AppColors.white : AppColors.grey,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }

  void viewDetailBottomSheet(AdoptionRequestModel model, bool isSentByMe) {
    DialogUtils.openBottomSheetDialog(
      context: context,
      isScrollControlled: true,
      contentWidget: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = UIHelper.screenHeight(context) * 0.9;
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonTitle(
                    title: "Adoption Request",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 2),
                  commonTitle(
                    title:
                        "Review the details of your adoption request below before the owner reviews and responds.",
                    fontSize: 14,
                    color: AppColors.grey,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: cubit
                          .getRequestStatusColor(model.status)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: commonTitle(
                        title: cubit.getRequestTitle(model.status, isSentByMe),
                        fontSize: 12,
                        textAlign: TextAlign.start,
                        color: cubit.getRequestStatusColor(model.status),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  petSummaryView(model),
                  const SizedBox(height: 20),
                  petBuyerDetail(model, isSentByMe),
                  const SizedBox(height: 20),
                  petOwnerDetail(model, !isSentByMe),
                  if (isSentByMe) ...[
                    const SizedBox(height: 30),
                    if (model.status == AdoptionStatus.pending) ...[
                      acceptOrRejectView(
                        onAccept: () {
                          cubit.acceptOrRejectRequest(
                            context: context,
                            requestId: model.requestId,
                            status: AdoptionStatus.approved,
                          );
                        },
                        onReject: () {
                          cubit.acceptOrRejectRequest(
                            context: context,
                            requestId: model.requestId,
                            status: AdoptionStatus.rejected,
                          );
                        },
                      ),
                    ] else if (model.status == AdoptionStatus.approved) ...[
                      commonButtonView(
                        context: context,
                        buttonText: "Collect Payment",
                        onClicked: () {},
                      ),
                    ],
                  ] else ...[
                    const SizedBox(height: 30),
                    if (model.status == AdoptionStatus.rejected)
                      commonButtonView(
                        context: context,
                        buttonText: "Find Another Pet",
                        onClicked: () {
                          context.goNamed(Routes.dashBoardScreen);
                        },
                      ),
                  ],
                  const SizedBox(height: 60),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget petSummaryView(AdoptionRequestModel model) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Pet Summary",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBgColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 60,
                    minHeight: 60,
                    maxWidth: 70,
                    maxHeight: 70,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: commonNetworkImage(
                      imageUrl: model.petImage,
                      borderRadius: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 5,
                        children: [
                          Flexible(
                            child: commonTitle(
                              title: model.petName,
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                              overFlow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Flexible(
                            child: commonTitle(
                              title: model.petBreed,
                              maxLines: 1,
                              overFlow: TextOverflow.ellipsis,
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      commonTitle(
                        title:
                            "${model.petGender} ${AppStrings.dot} ${model.petAge} ${AppStrings.old}",
                        fontSize: 14,
                        color: AppColors.grey,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    commonTitle(
                      title: CommonMethods().formatPrice(model.petPrice),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                    commonTitle(
                      title: AppStrings.adoptionPrice,
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget petOwnerDetail(AdoptionRequestModel model, bool isSentByMe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Owner Details",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,

          decoration: BoxDecoration(
            color: AppColors.inputBgColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    ClipOval(
                      child: commonNetworkImage(
                        imageUrl: model.petOwnerProfileImage,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          commonTitle(
                            title: "Hello,${model.ownerName}",
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          commonTitle(
                            title: model.ownerEmail,
                            fontSize: 12,
                            color: AppColors.grey,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    if (isSentByMe)
                      GestureDetector(
                        onTap: () {
                          CommonMethods.call(
                            CommonMethods().formatPhone(model.ownerPhone),
                          );
                        },
                        child: SvgPicture.asset(AppImages.icNeedHelp),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: commonDottedLine(),
                ),
                const SizedBox(height: 15),
                commonTitle(
                  title: "Address",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                commonTitle(
                  title: model.ownerAddress,
                  color: AppColors.grey,
                  fontSize: 14,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget petBuyerDetail(AdoptionRequestModel model, bool isSentByMe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Adopter Detail",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,

          decoration: BoxDecoration(
            color: AppColors.inputBgColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    ClipOval(
                      child: commonNetworkImage(
                        imageUrl: model.petBuyerProfileImage,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 5,
                            children: [
                              commonTitle(
                                title: model.fullName,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                              CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                radius: 3,
                              ),
                              commonTitle(
                                title: model.experience
                                    ? "Pet Experience"
                                    : "Not Experienced",
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                          commonTitle(
                            title: model.email,
                            fontSize: 12,
                            color: AppColors.grey,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    if (isSentByMe)
                      GestureDetector(
                        onTap: () {
                          CommonMethods.call(
                            CommonMethods().formatPhone(model.phone),
                          );
                        },
                        child: SvgPicture.asset(AppImages.icNeedHelp),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: commonDottedLine(),
                ),
                const SizedBox(height: 10),
                commonTitle(
                  title: model.message,
                  color: AppColors.grey,
                  fontSize: 14,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget statusView(AdoptionStatus status) {
    final isApproved = status == AdoptionStatus.approved;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: (isApproved ? AppColors.greenColor : AppColors.redColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: commonTitle(
          title: isApproved ? "Approved" : "Rejected",
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
