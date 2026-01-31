import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/bloc/dashboardBloc/dashboard_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/screens/adtoption/pet_adoption_screen.dart';
import 'package:paw_pal_mobile/screens/home/home_screen.dart';
import 'package:paw_pal_mobile/screens/hospital/vet_care_screen.dart';
import 'package:paw_pal_mobile/screens/product/product_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final ValueNotifier<int> selectedTab = ValueNotifier(0);
  late DashboardCubit cubit;
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
  }

  @override
  void dispose() {
    selectedTab.dispose();
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
              return IndexedStack(
                index: index,
                children: screens,
              );
            },
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
}
