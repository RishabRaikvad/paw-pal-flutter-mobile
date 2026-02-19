
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/bloc/dashboardBloc/dashboard_cubit.dart';
import 'package:paw_pal_mobile/bloc/homeCubit/home_cubit.dart';
import 'package:paw_pal_mobile/bloc/myAccountBloc/my_account_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/model/category_model.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';
import 'package:shimmer/shimmer.dart';

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
  late MyAccountCubit myAccountCubit;
  late HomeCubit cubit;

  @override
  void initState() {
    super.initState();
    dashboardCubit = context.read<DashboardCubit>();
    myAccountCubit = context.read<MyAccountCubit>();
    cubit = context.read<HomeCubit>();
    myAccountCubit.loadMyAccount();
    cubit.loadHomeData();
  }

  @override
  void dispose() {
    searchController.dispose();
    selectedPetCategory.dispose();
    super.dispose();
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
            const SizedBox(height: 10),
            buildProfileView(),
            const SizedBox(height: 30),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoadState) {
                    return homeShimmer();
                  } else if (state is HomeErrorState) {
                    return commonTitle(title: state.error);
                  }
                  return CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: commonSearchBar(
                          controller: searchController,
                          onSearchChange: (String? value) {},
                          onSearch: (String value) {},
                          title: "Search pets, products & care..."
                        ),
                      ),
                      SliverToBoxAdapter(child: const SizedBox(height: 30)),
                      SliverToBoxAdapter(child: buildPetCategoryView()),
                      buildPetView(),
                      SliverToBoxAdapter(child: const SizedBox(height: 30)),
                      SliverToBoxAdapter(child: buildShopCategoryView()),
                      buildShopView(),
                      SliverToBoxAdapter(child: const SizedBox(height: 30)),
                      SliverToBoxAdapter(child: buildPetCareVideoHeader()),
                      buildPetCareVideoList(),
                      SliverToBoxAdapter(child: const SizedBox(height: 100)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileView() {
    return BlocBuilder<MyAccountCubit, MyAccountState>(
      builder: (context, state) {
        if (state is LoadMyAccountState) {
          return headerShimmer();
        } else if (state is ErrorMyAccountState) {
          return commonTitle(title: state.error);
        }
        return Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade200,
              child: ClipOval(
                child: commonNetworkImage(
                  imageUrl: myAccountCubit.getProfileImage(),
                  height: 80,
                  width: 80,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonTitle(
                  title: "Hello, ${myAccountCubit.getFullName()}",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                commonTitle(
                  title:
                      "${myAccountCubit.getCity()}, ${myAccountCubit.getState()}",
                  fontSize: 13,
                  color: AppColors.grey,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // context.read<ProfileCubit>().resetPetData();
                // context.read<ProfileCubit>().addMorePet = true;
                context.pushNamed(Routes.myAccountScreen);
              },
              child: SvgPicture.asset(AppImages.icSetting),
            ),
          ],
        );
      },
    );
  }

  Widget buildPetCategoryView() {
    const int maxVisibleItems = 6;
    bool hasMore = listCategory.length > maxVisibleItems;
    int visibleItemCount = hasMore ? maxVisibleItems : listCategory.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeaderWithSeeAll(
          title: "Find What You Need",
          onTap: () => dashboardCubit.onTabChange(1),
        ),
        const SizedBox(height: 20),

        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: visibleItemCount,
            itemBuilder: (context, index) {
              final category = listCategory[index];
              final isLastCategory = hasMore && index == maxVisibleItems - 1;

              return ValueListenableBuilder<int>(
                valueListenable: selectedPetCategory,
                builder: (context, selected, child) {
                  final isSelected = selected == index;

                  return Column(
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
                          margin: const EdgeInsets.only(right: 15),
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
                                ? const Icon(Icons.add, size: 26)
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
                        padding: const EdgeInsets.only(right: 15),
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
    final petCount = cubit.petCubit.petList.length > Constant.staticCount
        ? Constant.staticCount
        : cubit.petCubit.petList.length;
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 14,
        childAspectRatio: 0.75,
        //mainAxisExtent: 220,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final pet = cubit.petCubit.petList[index];
        return commonPetCard(
          petName: pet.pet.name,
          petBread: pet.pet.breed,
          img: pet.pet.mainImageUrl ?? "",
          price: pet.pet.petPrice,
        );
      }, childCount: petCount),
    );
  }

  Widget buildShopCategoryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeaderWithSeeAll(
          title: 'Everything Your Pet Needs',
          onTap: () {
            dashboardCubit.onTabChange(2);
          },
        ),
        const SizedBox(height: 20),
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
        sectionHeaderWithSeeAll(title: "Watch & Learn", onTap: () {}),
        const SizedBox(height: 10),
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

  Widget headerShimmer() {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 16,
                width: 140,
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
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget homeShimmer() {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: shimmerSearchBar()),
        SliverToBoxAdapter(child: const SizedBox(height: 25)),
        SliverToBoxAdapter(child: shimmerCategory()),
        shimmerGrid(),
        SliverToBoxAdapter(child: const SizedBox(height: 20)),
        shimmerGrid(),
        SliverToBoxAdapter(child: const SizedBox(height: 20)),
        shimmerVideoList(),
      ],
    );
  }

  Widget shimmerCategory() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(width: 40, height: 10, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  SliverList shimmerVideoList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      }, childCount: 3),
    );
  }

  Widget shimmerSearchBar() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
