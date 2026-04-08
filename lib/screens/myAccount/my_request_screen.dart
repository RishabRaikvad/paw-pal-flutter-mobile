import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/bloc/adoptionRequestBloc/adoption_request_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

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
            BlocBuilder<AdoptionRequestCubit, AdoptionRequestState>(
              builder: (context, state) {
                return CustomScrollView(slivers: [requestList()]);
              },
            ),
          ],
        ),
      ),
    );
  }

  SliverList requestList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final user = CommonMethods.getCurrentUser();
        if (user == null) return SizedBox.shrink();
        final request = cubit.filterAdoptionList[index];
        final isOwner = request.petOwnerId == user.uid;
        // return buildRequestView(
        //     isOwner: isOwner,
        //     date: request.createdAt,
        //     profileImage: isOwner ? request.petOwnerProfileImage : request.petBuyerProfileImage,
        //
        // );
      }, childCount: cubit.filterAdoptionList.length),
    );
  }

  Widget buildRequestView({
    required bool isOwner,
    required String profileImage,
    required String userName,
    required DateTime date
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBgColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                ClipOval(
                  child: commonNetworkImage(
                    imageUrl: profileImage,
                    width: 50,
                    height: 50,
                  ),
                ),
                Row(
                  children: [
                    commonTitle(
                      title: userName,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      maxLines: 1,
                      overFlow: TextOverflow.ellipsis,
                    ),
                    CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 5,
                    ),
                    commonTitle(title: cubit.timeAgo(date))

                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
