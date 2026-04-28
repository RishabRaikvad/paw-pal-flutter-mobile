import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/bloc/hospitalBloc/hospital_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/model/hospital_model.dart';
import 'package:paw_pal_mobile/utils/ui_helper.dart';

import '../../utils/commonWidget/gradient_background.dart';
import '../../utils/widget_helper.dart';

class VetCareScreen extends StatefulWidget {
  const VetCareScreen({super.key});

  @override
  State<VetCareScreen> createState() => _VetCareScreenState();
}

class _VetCareScreenState extends State<VetCareScreen> {
  final searchController = TextEditingController();
  late HospitalCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<HospitalCubit>();
    cubit.getHospitals();
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
            Align(
              alignment: Alignment.center,
              child: commonTitle(
                title: "Find a Veterinary Hospital",
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            searchView(),
            const SizedBox(height: 30),
            Flexible(
              child: BlocBuilder<HospitalCubit, HospitalState>(
                builder: (context, state) {
                  if (state is HospitalLoading) {
                    return hospitalShimmerView();
                  } else if (state is HospitalError) {
                    return Center(child: commonTitle(title: state.error));
                  }
                  return commonRefreshIndicator(
                    onRefresh: cubit.getHospitals,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: commonTitle(
                            title: "Veterinary Care Centers",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SliverToBoxAdapter(child: const SizedBox(height: 5)),
                        cubit.filteredHospital.isNotEmpty
                            ? careCenterList()
                            : SliverToBoxAdapter(
                                child: SizedBox(
                                  height: UIHelper.screenHeight(context) * 0.5,
                                  child: Center(
                                    child: commonTitle(
                                      title: "No Hospital Available",
                                    ),
                                  ),
                                ),
                              ),
                        SliverToBoxAdapter(child: const SizedBox(height: 100)),
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

  Widget searchView() {
    return commonSearchBar(
      controller: searchController,
      onSearchChange: (String? value) {
        cubit.searchHospital(value ?? "");
      },
      onSearch: (String value) {
        cubit.searchHospital(value);
      },
      title: "Search trusted hospitals...",
    );
  }

  SliverList careCenterList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final hospital = cubit.filteredHospital[index];
        return careCenterView(
          hospitalName: hospital.hospitalName,
          img: hospital.imageUrl,
          address: hospital.address,
          model: hospital,
          onTap: () => cubit.navigateToDetailPage(hospital, context),
        );
      }, childCount: cubit.filteredHospital.length),
    );
  }

  Widget careCenterView({
    required String img,
    required String hospitalName,
    required String address,
    required HospitalModel model,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonNetworkImage(
              imageUrl: img,
              boarderRadiusOnly: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              height: 200,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                spacing: 5,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 20,
                    children: [
                      Flexible(
                        child: commonTitle(
                          title: hospitalName,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          overFlow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          commonTitle(
                            title: "View Details",
                            color: AppColors.primaryColor,
                            fontSize: 14,
                            isUnderLine: true,
                          ),
                          SvgPicture.asset(AppImages.icViewDetailArrow),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppImages.icLocation),
                      Flexible(
                        child: commonTitle(
                          title: address,
                          fontSize: 14,
                          color: AppColors.grey,
                          maxLines: 1 ,
                          overFlow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      CircleAvatar(backgroundColor: AppColors.grey, radius: 3),
                      commonTitle(
                        title: cubit.isOpenNow(model)
                            ? "Open Now"
                            : "Close Now",
                        fontSize: 14,
                        color: cubit.isOpenNow(model)
                            ? AppColors.greenColor
                            : AppColors.redColor,
                        fontWeight: FontWeight.w600,
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

  Widget hospitalShimmerView() {
    return CustomScrollView(slivers: [shimmerListSliver(height: 250)]);
  }
}
