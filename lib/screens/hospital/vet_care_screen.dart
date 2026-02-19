import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';

import '../../utils/commonWidget/gradient_background.dart';
import '../../utils/widget_helper.dart';

class VetCareScreen extends StatefulWidget {
  const VetCareScreen({super.key});

  @override
  State<VetCareScreen> createState() => _VetCareScreenState();
}

class _VetCareScreenState extends State<VetCareScreen> {
  final searchController = TextEditingController();

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
                  careCenterList(),
                  SliverToBoxAdapter(child: const SizedBox(height: 100)),
                ],
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
      onSearchChange: (String? value) {},
      onSearch: (String value) {},
      title: "Search trusted hospitals...",
    );
  }

  SliverList careCenterList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return careCenterView();
      }, childCount: 10),
    );
  }

  Widget careCenterView() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonNetworkImage(
            imageUrl:
                "https://images.ctfassets.net/rt5zmd3ipxai/qjNkWMM9besACgCV3Xlub/d4bac39571e7238b4f9fafd8820cc377/Carson_Valley_Veterinary_Hospital_0245_-_60-40_AAHA_Accredited_Image.jpg?fit=fill&fm=webp&h=960&w=1564&q=7",
            boarderRadiusOnly: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
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
                        title: "PawHealth care",
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
                    commonTitle(
                      title: "Bangalore, Karnataka",
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                    CircleAvatar(backgroundColor: AppColors.grey, radius: 3),
                    commonTitle(
                      title: "Closed Now",
                      fontSize: 14,
                      color: AppColors.redColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
