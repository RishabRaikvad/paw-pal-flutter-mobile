import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/bloc/dashboardBloc/dashboard_cubit.dart';
import 'package:paw_pal_mobile/bloc/profileBloc/profile_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/category_model.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
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
  late DashboardCubit dashboardCubit;
  @override
  void initState() {
    super.initState();
    dashboardCubit = context.read<DashboardCubit>();
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
                  SliverToBoxAdapter(child: SizedBox(height: 30)),
                  SliverToBoxAdapter(child: buildShopCategoryView()),
                  buildShopView(),
                  SliverToBoxAdapter(child: SizedBox(height: 30)),
                  SliverToBoxAdapter(child: buildPetCareVideoHeader()),
                  buildPetCareVideoList(),
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
        GestureDetector(
          onTap: (){
            context.read<ProfileCubit>().resetPetData();
            context.read<ProfileCubit>().addMorePet = true;
            context.pushNamed(Routes.petProfileScreen);
          },
            child: SvgPicture.asset(AppImages.icSetting)),
      ],
    );
  }

  Widget buildPetCategoryView() {
    const int maxVisibleItems = 6;

    bool hasMore = listCategory.length > maxVisibleItems;

    int visibleItemCount = hasMore ? maxVisibleItems : listCategory.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeaderWithSeeAll(title: "Find What You Need", onTap: (){
          dashboardCubit.onTabChange(1);
        }),
        SizedBox(height: 20),
        SizedBox(
          height: 100,
          child: ValueListenableBuilder(
            valueListenable: selectedPetCategory,
            builder: (context, selected, child) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: visibleItemCount,
                itemBuilder: (context, index) {
                  bool isLastCategory = hasMore && index == maxVisibleItems - 1;
                  final category = listCategory[index];
                  final isSelected = selected == index;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isLastCategory) {
                            print("Open all categories");
                          } else {
                            selectedPetCategory.value = index;
                          }
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
                            child: isLastCategory
                                ? Icon(
                              Icons.add,
                              size: 26,
                              color: AppColors.grey,
                            )
                                : SvgPicture.asset(
                              category.img,
                              width: 26,
                              height: 26,
                              colorFilter: ColorFilter.mode(
                                isSelected
                                    ? Colors.white
                                    : AppColors.grey,
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
                          title: isLastCategory ? "More" : category.name,
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
        childAspectRatio: 0.75,
        //mainAxisExtent: 220,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        return commonPetCard(index);
      }, childCount: 10),
    );
  }

  Widget buildShopCategoryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeaderWithSeeAll(title: 'Everything Your Pet Needs',  onTap: () {
          dashboardCubit.onTabChange(2);
        }),
        SizedBox(height: 20),
      ],
    );
  }

  SliverGrid buildShopView() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 14,
        childAspectRatio: 0.65,
        // mainAxisExtent: 245,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        return commonProductCard(index);
      }, childCount: 10),
    );
  }

  Widget buildPetCareVideoHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeaderWithSeeAll(title: "Watch & Learn",onTap: (){}),
        SizedBox(height: 10),
      ],
    );
  }

  SliverList buildPetCareVideoList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return GestureDetector(
          onTap: () {
            CommonMethods().openYoutube(
              "https://youtu.be/A296Y5jivxw?si=Qirap-_F2rWmzxak",
            );
          },
          child: commonPetCareVideoCard(index),
        );
      }, childCount: 5),
    );
  }
}
