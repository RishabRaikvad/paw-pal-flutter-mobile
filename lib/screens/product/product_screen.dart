import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_mobile/bloc/productBloc/product_cubit.dart';

import '../../core/AppColors.dart';
import '../../utils/commonWidget/gradient_background.dart';
import '../../utils/ui_helper.dart';
import '../../utils/widget_helper.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final searchController = TextEditingController();
  late ProductCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<ProductCubit>();
    cubit.getProductsWithCategory();
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
                title: "Find Your New Furry Friend",
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            commonSearchBar(
              controller: searchController,
              onSearchChange: (String? value) {},
              onSearch: (String value) {},
              title: "Search pets, products & care...",
            ),
            const SizedBox(height: 30),
            Flexible(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoadState) {
                    return productShimmerView();
                  } else if (state is ProductErrorState) {
                    return Center(child: commonTitle(title: state.error));
                  }
                  return commonRefreshIndicator(
                    onRefresh: cubit.getProductsWithCategory,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(child: categoryFilterList()),
                        SliverToBoxAdapter(child: const SizedBox(height: 20)),
                        cubit.filteredProducts.isEmpty
                            ? SliverToBoxAdapter(
                          child: SizedBox(
                            height: UIHelper.screenHeight(context) * 0.5,
                            child: Center(
                              child: commonTitle(title: "No Product Found"),
                            ),
                          ),
                        )
                            : buildShopView(),
                        SliverToBoxAdapter(child: const SizedBox(height: 100)),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
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
        final product = cubit.filteredProducts[index];
        return commonProductCard( imgUrl: product.mainProductImage,
          price: cubit.getProductPrice(product),
          productName: product.name,
          rating: product.rating,
          size: cubit.getProductSize(product) ?? "",);
      }, childCount: cubit.filteredProducts.length),
    );
  }

  Widget productShimmerView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: categoryFilterShimmer()),
        SliverToBoxAdapter(child: const SizedBox(height: 20)),
        shimmerGrid( count: 6),
      ],
    );
  }

  Widget categoryFilterList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        commonTitle(
          title: "Everything Your Store Offers",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cubit.lstCategory.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () => cubit.selectAllFilter(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: cubit.isAllFilterSelected
                          ? AppColors.primaryColor
                          : AppColors.primaryBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: commonTitle(
                      title: "All",
                      color: cubit.isAllFilterSelected
                          ? AppColors.white
                          : AppColors.grey,
                      fontSize: 14,
                      fontWeight: cubit.isAllFilterSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                );
              }

              final category = cubit.lstCategory[index - 1];

              final isSelected =
                  cubit.filterCategory?.categoryName == category.categoryName;

              return GestureDetector(
                onTap: () => cubit.selectFilterCategory(category, index),
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
