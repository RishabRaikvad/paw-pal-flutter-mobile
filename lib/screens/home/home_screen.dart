import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/bloc/dashboardBloc/dashboard_cubit.dart';
import 'package:paw_pal_mobile/bloc/homeCubit/home_cubit.dart';
import 'package:paw_pal_mobile/bloc/myAccountBloc/my_account_cubit.dart';
import 'package:paw_pal_mobile/bloc/petCubit/pet_cubit.dart';
import 'package:paw_pal_mobile/bloc/petDetailBloc/pet_detail_cubit.dart';
import 'package:paw_pal_mobile/bloc/productDetailBloc/product_detail_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/model/category_model.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/productBloc/product_cubit.dart';
import '../../utils/commonWidget/gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  late DashboardCubit dashboardCubit;
  late MyAccountCubit myAccountCubit;
  late HomeCubit cubit;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void initScreen() async {
    dashboardCubit = context.read<DashboardCubit>();
    myAccountCubit = context.read<MyAccountCubit>();
    cubit = context.read<HomeCubit>();
    myAccountCubit.loadMyAccount();
    await loadHomeData();
  }

  Future<void> loadHomeData() async {
    await cubit.loadHomeData();
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
                  return commonRefreshIndicator(
                    onRefresh: loadHomeData,
                    child: CustomScrollView(
                      physics: BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: commonSearchBar(
                            controller: searchController,
                            onSearchChange: (String? value) {},
                            onSearch: (String value) {},
                            title: "Search pets, products & care...",
                          ),
                        ),
                        SliverToBoxAdapter(child: const SizedBox(height: 30)),
                        buildPetSection(),
                        SliverToBoxAdapter(child: const SizedBox(height: 30)),
                        buildProductSection(),
                        SliverToBoxAdapter(child: const SizedBox(height: 30)),
                        SliverToBoxAdapter(child: buildPetCareVideoHeader()),
                        buildPetCareVideoList(),
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
                context.pushNamed(Routes.myAccountScreen);
              },
              child: SvgPicture.asset(AppImages.icSetting),
            ),
          ],
        );
      },
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
          onTap: () {
            context.read<PetDetailCubit>().navigateToPetDetailScreen(
              context,
              pet,
            );
          },
        );
      }, childCount: petCount),
    );
  }

  Widget buildProductSection() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(child: buildShopCategoryView()),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            if (cubit.productCubit.filteredProducts.isEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: Center(child: commonTitle(title: "No Product Found")),
                ),
              )
            else
              buildShopView(),
          ],
        );
      },
    );
  }

  Widget buildPetSection() {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(child: buildPetCategoryView()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            if (cubit.petCubit.filteredPets.isEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: Center(child: commonTitle(title: "No Pet Found")),
                ),
              )
            else
              buildPetView(),
          ],
        );
      },
    );
  }

  Widget buildShopCategoryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeaderWithSeeAll(
          title: 'Everything Your Pet Needs',
          onTap: () {
            cubit.productCubit.resetFilterData();
            dashboardCubit.onTabChange(2);
          },
        ),
        const SizedBox(height: 20),
        categoryFilterList(),
      ],
    );
  }

  Widget buildPetCategoryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeaderWithSeeAll(
          title: 'Find What You Need',
          onTap: () {
            cubit.petCubit.resetFilters();
            dashboardCubit.onTabChange(1);
          },
        ),
        const SizedBox(height: 20),
        categoryPetFilterList(),
      ],
    );
  }

  SliverGrid buildShopView() {
    final productCount =
        cubit.productCubit.filteredProducts.length > Constant.staticCount
        ? Constant.staticCount
        : cubit.productCubit.filteredProducts.length;
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 14,
        childAspectRatio: 0.65,
      ),
      delegate: SliverChildBuilderDelegate((ctx, index) {
        final product = cubit.productCubit.filteredProducts[index];
        return commonProductCard(
          imgUrl: product.mainProductImage,
          price: cubit.productCubit.getProductPrice(product),
          productName: product.name,
          rating: product.rating,
          size: cubit.productCubit.getProductSize(product) ?? "",
          onTap: () {
            context.read<ProductDetailCubit>().navigateToProductDetailScreen(
              context: context,
              model: product,
            );
          },
        );
      }, childCount: productCount),
    );
  }

  Widget buildPetCareVideoHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeaderWithSeeAll(
          title: "Watch & Learn",
          onTap: () {
            context.pushNamed(Routes.petCareVideoScreen);
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  SliverList buildPetCareVideoList() {
    final videoCount =
        cubit.videoCubit.lstPetCareVideo.length > Constant.staticCount
        ? Constant.staticCount
        : cubit.videoCubit.lstPetCareVideo.length;
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final video = cubit.videoCubit.lstPetCareVideo[index];
        return commonPetCareVideoCard(
          thumbnail: video.thumbnail,
          channelImage: video.ownerImage,
          channelName: video.ownerName,
          duration: video.videoTime,
          videoTitle: video.videoTitle,
          videoUrl: video.videoUrl,
        );
      }, childCount: videoCount),
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
        SliverToBoxAdapter(child: categoryFilterShimmer()),
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

  Widget categoryFilterList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cubit.productCubit.lstCategory.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () => cubit.productCubit.selectAllFilter(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: cubit.productCubit.isAllFilterSelected
                          ? AppColors.primaryColor
                          : AppColors.primaryBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: commonTitle(
                      title: "All",
                      color: cubit.productCubit.isAllFilterSelected
                          ? AppColors.white
                          : AppColors.grey,
                      fontSize: 14,
                      fontWeight: cubit.productCubit.isAllFilterSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                );
              }

              final category = cubit.productCubit.lstCategory[index - 1];

              final isSelected =
                  cubit.productCubit.filterCategory?.categoryName ==
                  category.categoryName;

              return GestureDetector(
                onTap: () =>
                    cubit.productCubit.selectFilterCategory(category, index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.primaryBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: commonTitle(
                    title: category.categoryName,
                    color: isSelected ? AppColors.white : AppColors.grey,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget categoryPetFilterList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cubit.petCubit.lstPetCategory.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () => cubit.petCubit.selectAllFilter(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: cubit.petCubit.isAllFilterSelected
                          ? AppColors.primaryColor
                          : AppColors.primaryBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: commonTitle(
                      title: "All",
                      color: cubit.petCubit.isAllFilterSelected
                          ? AppColors.white
                          : AppColors.grey,
                      fontSize: 14,
                      fontWeight: cubit.petCubit.isAllFilterSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                );
              }

              final category = cubit.petCubit.lstPetCategory[index - 1];

              final isSelected =
                  cubit.petCubit.filterCategory?.categoryName ==
                  category.categoryName;

              return GestureDetector(
                onTap: () =>
                    cubit.petCubit.selectFilterCategory(category, index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.primaryBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: commonTitle(
                    title: category.categoryName,
                    color: isSelected ? AppColors.white : AppColors.grey,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
