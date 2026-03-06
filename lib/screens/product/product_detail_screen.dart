import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/bloc/productDetailBloc/product_detail_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/ui_helper.dart';

import '../../utils/widget_helper.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductDetailCubit cubit;
  late PageController pageController;
  late ScrollController thumbController;

  @override
  void initState() {
    super.initState();
    cubit = context.read<ProductDetailCubit>();
    pageController = PageController(initialPage: cubit.selectedImage);
    thumbController = ScrollController();
  }

  @override
  void dispose() {
    cubit.resetData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(child: mainView()),
      bottomNavigationBar: SafeArea(child: Container(child: addToCartView())),
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
              title: "Product Details",
              isShowTitle: true,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
                builder: (context, state) {
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: productImageView()),
                      SliverToBoxAdapter(child: const SizedBox(height: 20)),
                      SliverToBoxAdapter(child: productNameAndQuantityView()),
                      if (cubit.productModel?.variantType !=
                          VariantType.none) ...[
                        SliverToBoxAdapter(child: const SizedBox(height: 10)),
                        SliverToBoxAdapter(child: netWeightView()),
                      ],
                      SliverToBoxAdapter(child: const SizedBox(height: 15)),
                      SliverToBoxAdapter(child: productDescriptionView()),
                      SliverToBoxAdapter(child: const SizedBox(height: 20)),
                      SliverToBoxAdapter(child: servicesFeatureView()),
                      SliverToBoxAdapter(child: const SizedBox(height: 30)),
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

  Widget productImageView() {
    final image = cubit.productModel?.getAllImages;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBgColor,
        borderRadius: BorderRadiusDirectional.circular(24),
      ),
      child: Column(
        children: [
          SizedBox(
            height: UIHelper.screenHeight(context) * 0.38,
            child: PageView.builder(
              itemCount: image?.length,
              controller: pageController,
              onPageChanged: (index) {
                cubit.changeImage(index);
                thumbController.animateTo(
                  index * 70,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              itemBuilder: (context, index) {
                final img = image?[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  child: commonNetworkImage(
                    imageUrl: img ?? "",
                    borderRadius: 20,
                    fit: BoxFit.fill,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                controller: thumbController,
                itemBuilder: (context, index) {
                  final isSelected = cubit.selectedImage == index;
                  final img = image?[index];
                  return GestureDetector(
                    onTap: () {
                      cubit.changeImage(index);
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : AppColors.white,
                        ),
                      ),
                      child: commonNetworkImage(
                        imageUrl: img ?? "",
                        borderRadius: 10,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: image?.length ?? 0,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget productNameAndQuantityView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 20,
          children: [
            Flexible(
              child: commonTitle(
                title: cubit.productModel?.name ?? "",
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ),
            Row(
              spacing: 3,
              children: [
                GestureDetector(
                  onTap: cubit.decreaseProductQuantity,
                  child: Icon(
                    Icons.remove_circle,
                    color: AppColors.primaryColor,
                    size: 30,
                  ),
                ),
                commonTitle(
                  title: cubit.productQuantity.toString(),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                GestureDetector(
                  onTap: cubit.increaseProductQuantity,
                  child: Icon(
                    Icons.add_circle,
                    color: AppColors.primaryColor,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
        commonTitle(
          title: CommonMethods().formatPrice(cubit.getTotalProductPrice()),
          color: AppColors.primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget netWeightView() {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Net Weight",
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final isSelected = cubit.selectedVariant == index;
              final variant = cubit.productModel?.variants[index];
              return GestureDetector(
                onTap: () => cubit.changeVariant(index),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.grey,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: commonTitle(
                        title: variant?.title ?? "",
                        fontSize: 13,
                        color: isSelected ? AppColors.white : AppColors.grey,
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: cubit.productModel?.variants.length ?? 0,
          ),
        ),
      ],
    );
  }

  Widget productDescriptionView() {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Description",
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        commonTitle(
          title: cubit.productModel?.description ?? "",
          color: AppColors.grey,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget addToCartView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
      child: SvgPicture.asset(AppImages.icAddToCartBtn),
    );
  }

  Widget servicesFeatureView() {
    return Column(
      spacing: 10,
      children: [
        Row(
          spacing: 10,
          children: [
            Flexible(
              child: servicesFeatureCard(
                img: AppImages.icQualityAssured,
                title: "Quality Assured",
                subTitle: "Verified",
              ),
            ),
            Flexible(
              child: servicesFeatureCard(
                img: AppImages.icSecurePayment,
                title: "Secure Payments",
                subTitle: "Protected",
              ),
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Flexible(
              child: servicesFeatureCard(
                img: AppImages.icCustomerTrusted,
                title: "Customer Trusted",
                subTitle: "Trusted & Reliable",
              ),
            ),
            Flexible(
              child: servicesFeatureCard(
                img: AppImages.icFastDelivery,
                title: "top Fast Delivery",
                subTitle: "3 days delivery",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget servicesFeatureCard({
    required String img,
    required String title,
    required String subTitle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.inputBgColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 10,
        children: [
          SvgPicture.asset(img),
          Flexible(
            child: Column(
              spacing: 3,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonTitle(
                  title: title,
                  fontSize: 11,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w600,
                ),
                commonTitle(
                  title: subTitle,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                  textAlign: TextAlign.start,

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
