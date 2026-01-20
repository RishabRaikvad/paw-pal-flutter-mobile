import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/category_model.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

import '../../utils/commonWidget/gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  ValueNotifier<int> selectedPetCategory = ValueNotifier(0);
  List<PetCategory> listCategory = [
    PetCategory("All", AppImages.icAll),
    PetCategory("Dog", AppImages.icDog),
    PetCategory("Cat", AppImages.icCat),
    PetCategory("Bird", AppImages.icBird),
    PetCategory("Fish", AppImages.icFish),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
        body: GradientBackground(child: mainView()));
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            buildProfileView(),
            SizedBox(height: 30),
            Expanded(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: commonSearchBar(
                      controller: searchController,
                      onSearchChange: (String? value) {},
                      onSearch: (String value) {},
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 30)),
                  SliverToBoxAdapter(child: buildPetCategoryView()),
                  buildPetView(),
                  SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileView() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey.shade200,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'https://i.pravatar.cc/150?img=3',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) =>
                  Icon(Icons.person, size: 40, color: Colors.grey),
            ),
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonTitle(
              title: "Hello, Jasmin Patel",
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            commonTitle(
              title: "Ahmedabad, Gujarat",
              fontSize: 13,
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        Spacer(),
        SvgPicture.asset(AppImages.icSetting),
      ],
    );
  }

  Widget buildPetCategoryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            commonTitle(
              title: "Find What You Need",
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            commonTitle(
              title: "See all",
              isUnderLine: true,
              color: AppColors.primaryColor,
            ),
          ],
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 100,
          child: ValueListenableBuilder(
            valueListenable: selectedPetCategory,
            builder: (context, selected, child) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: listCategory.length,
                itemBuilder: (context, index) {
                  final category = listCategory[index];
                  final isSelected = selected == index;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectedPetCategory.value = index;
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.white,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              category.img,
                              width: 26,
                              height: 26,
                              colorFilter: ColorFilter.mode(
                                isSelected ? Colors.white : AppColors.grey,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: commonTitle(
                          title: category.name,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.primaryColor
                              : AppColors.grey,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  SliverGrid buildPetView() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 14,
        childAspectRatio: 1 / 1.35,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        return myPetView(index);
      }, childCount: 30),
    );
  }

  Widget myPetView(int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: "https://placedog.net/500/500?id=${index+1}",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 140,
                    placeholder: (_, __) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
                Positioned(
                  right: 0,
                    bottom: -18,
                    left: 0,
                    child: SvgPicture.asset(AppImages.icAdoptMe)),
              ],
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      spacing: 3,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonTitle(
                          title: "Reilybfffffffffffffffffff",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          overFlow: TextOverflow.ellipsis,
                        ),
                        commonTitle(
                          title: "Siberian Husky",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.grey,
                          maxLines: 1,
                          overFlow:  TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 18),
                  commonTitle(
                    title: CommonMethods().formatPrice(5000),
                    fontSize: 14,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  )
                ],
              ),
            ),



          ],
        ),
      ),
    );
  }
}
