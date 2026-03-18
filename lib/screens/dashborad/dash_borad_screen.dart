import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/bloc/cartBloc/cart_cubit.dart';
import 'package:paw_pal_mobile/bloc/dashboardBloc/dashboard_cubit.dart';
import 'package:paw_pal_mobile/bloc/productBloc/product_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/screens/adtoption/pet_adoption_screen.dart';
import 'package:paw_pal_mobile/screens/home/home_screen.dart';
import 'package:paw_pal_mobile/screens/hospital/vet_care_screen.dart';
import 'package:paw_pal_mobile/screens/product/product_screen.dart';
import 'package:paw_pal_mobile/utils/ui_helper.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

import '../../model/cart_model.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late DashboardCubit cubit;
  late CartCubit cartCubit;
  final List<Widget> screens = const [
    HomeScreen(),
    PetAdoptionScreen(),
    ProductScreen(),
    VetCareScreen(),
  ];

  final List<String> selectedIcons = const [
    AppImages.icSelectedHome,
    AppImages.icSelectedAdoption,
    AppImages.icSelectedShop,
    AppImages.icSelectedHospital,
  ];

  final List<String> unSelectedIcons = const [
    AppImages.icUnselectedHome,
    AppImages.icUnSelectedAdoption,
    AppImages.icUnSelectedShop,
    AppImages.icUnSelectedHospital,
  ];

  final List<String> labels = const ['Home', 'Adoption', 'Shop', 'Vet Care'];

  @override
  void initState() {
    super.initState();
    cubit = context.read<DashboardCubit>();
    cartCubit = context.read<CartCubit>();
  }

  @override
  void dispose() {
    cubit.selectedTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: cubit.selectedTab,
            builder: (context, index, _) {
              return IndexedStack(index: index, children: screens);
            },
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 90,
            left: 0,
            right: 0,
            child: StreamBuilder<List<CartModel>>(
              stream: cartCubit.getCartItems(),
              builder: (context, snapshot) {
                final cartItems = snapshot.data ?? [];

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                    );
                  },
                  transitionBuilder: (child, animation) {
                    final slide = Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(animation);

                    return SlideTransition(position: slide, child: child);
                  },
                  child: cartItems.isEmpty
                      ? const SizedBox(key: ValueKey("empty"), height: 0)
                      : viewCartBar(cartItems),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ValueListenableBuilder<int>(
              valueListenable: cubit.selectedTab,
              builder: (context, index, _) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(selectedIcons.length, (i) {
                          final isSelected = index == i;
                          return GestureDetector(
                            onTap: () {
                              if (i == 0 || i == 2) {
                                context.read<ProductCubit>().resetFilterData();
                              }
                              cubit.onTabChange(i);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              padding: isSelected
                                  ? const EdgeInsets.symmetric(horizontal: 1)
                                  : const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.linearBgColor
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.transparent,
                                    child: SvgPicture.asset(
                                      isSelected
                                          ? selectedIcons[i]
                                          : unSelectedIcons[i],
                                    ),
                                  ),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: isSelected
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10,
                                            ),
                                            child: Text(
                                              labels[i],
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: Constant.fontFamily,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget viewCartBar(List<CartModel> cartItems) {
    final latestItems = cartItems.reversed.take(2).toList();
    final bool isFirstItem = cartItems.length == 1;

    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: cartItems.isEmpty
            ? const SizedBox.shrink()
            : isFirstItem
            ? FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 500)),
                builder: (context, snapshot) {
                  bool showText =
                      snapshot.connectionState == ConnectionState.done;
                  return _buildBar(cartItems, latestItems, showText);
                },
              )
            : _buildBar(
                cartItems,
                latestItems,
                true,
              ), // show text immediately for 2+ items
      ),
    );
  }

  Widget _buildBar(
    List<CartModel> cartItems,
    List<CartModel> latestItems,
    bool showText,
  ) {
    final bool isFirstItem = cartItems.length == 1;

    final double avatarRadius = 22;
    final double spacing = 22;

    final double stackWidth = latestItems.length <= 1
        ? avatarRadius * 2
        : (latestItems.length - 1) * spacing + avatarRadius * 2;

    final EdgeInsetsGeometry containerPadding = isFirstItem
        ? const EdgeInsets.symmetric(horizontal: 2, vertical: 2)
        : const EdgeInsets.symmetric(horizontal: 8, vertical: 5);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: (){
          context.pushNamed(Routes.checkOutScreen);
        },
        child: Container(
          key: ValueKey(cartItems.length),
          padding: containerPadding,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(80),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: showText ? 8.0 : 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: stackWidth,
                  height: avatarRadius * 2,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: latestItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final image = entry.value.productMainImage;

                      return Positioned(
                        left: index * spacing,
                        top: 0,
                        child: CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: avatarRadius - 2,
                            child: commonNetworkImage(
                              imageUrl: image,
                              width: (avatarRadius - 2) * 2,
                              height: (avatarRadius - 2) * 2,
                              fit: BoxFit.cover,
                              borderRadius: avatarRadius - 2,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: showText
                      ? Row(
                          key: const ValueKey("cartText"),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonTitle(
                                    title: "View Buy List",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                  commonTitle(
                                    title: "${cartItems.length} items",
                                    fontSize: 14,
                                    color: AppColors.white,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            SvgPicture.asset(AppImages.icCartArrow),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
