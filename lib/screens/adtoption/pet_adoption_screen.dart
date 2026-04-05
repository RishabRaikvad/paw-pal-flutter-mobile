import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/bloc/petCubit/pet_cubit.dart';
import 'package:paw_pal_mobile/bloc/petDetailBloc/pet_detail_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/dialog_utils.dart';
import 'package:paw_pal_mobile/utils/ui_helper.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

class PetAdoptionScreen extends StatefulWidget {
  const PetAdoptionScreen({super.key});

  @override
  State<PetAdoptionScreen> createState() => _PetAdoptionScreenState();
}

class _PetAdoptionScreenState extends State<PetAdoptionScreen> {
  final searchController = TextEditingController();
  late PetCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<PetCubit>();
    loadPetData();
  }

  Future<void> loadPetData() async {
    await cubit.loadPets();
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
            searchView(),
            const SizedBox(height: 30),
            Expanded(
              child: BlocBuilder<PetCubit, PetState>(
                builder: (context, state) {
                  if (state is PetLoadingState) {
                    return petLoadView();
                  } else if (state is PetErrorState) {
                    return commonTitle(title: state.error);
                  }
                  return commonRefreshIndicator(
                    onRefresh: loadPetData,
                    child: CustomScrollView(
                      slivers: [
                        cubit.filteredPets.isNotEmpty
                            ? buildPetView()
                            : SliverToBoxAdapter(
                                child: SizedBox(
                                  height: UIHelper.screenHeight(context) * 0.5,
                                  child: Center(child: commonTitle(title: "Pet Not Found")),
                                ),
                              ),
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
    return Row(
      spacing: 10,
      children: [
        Flexible(
          child: commonSearchBar(
            controller: searchController,
            onSearchChange: (String? value) {},
            onSearch: (String value) {},
            title: "Search pets, products & care...",
          ),
        ),
        GestureDetector(
          onTap: () {
            filterBottomSheet();
          },
          child: SvgPicture.asset(AppImages.icFilter, height: 50, width: 50),
        ),
      ],
    );
  }

  SliverGrid buildPetView() {
    final petCount = cubit.filteredPets.length;
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 14,
        childAspectRatio: 0.75,
        //mainAxisExtent: 220,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final pet = cubit.filteredPets[index];
        return commonPetCard(
          petName: pet.pet.name,
          petBread: pet.pet.breed,
          img: pet.pet.mainImageUrl,
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

  Widget petLoadView() {
    return CustomScrollView(slivers: [shimmerGrid(count: 6)]);
  }

  void filterBottomSheet() {
    DialogUtils.openBottomSheetDialog(
      context: context,
      isScrollControlled: true,
      contentWidget: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = UIHelper.screenHeight(context) * 0.8;
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: BlocBuilder<PetCubit, PetState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    commonTitle(
                      title: "Find Your Match",
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                    commonTitle(
                      title: "Adjust filters to find your perfect match.",
                      color: AppColors.grey,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 15),
                    commonFilterChipWidget(
                      title: "Price Range",
                      items: cubit.priceRanges,
                      isSelected: (e) => cubit.tempSelectedPrices.contains(e),
                      onTap: (e) => cubit.togglePrice(e),
                    ),
                    const SizedBox(height: 15),
                    commonFilterChipWidget(
                      title: "Age",
                      items: cubit.ages,
                      isSelected: (e) => cubit.tempSelectedAges.contains(e),
                      onTap: (e) => cubit.toggleAge(e),
                    ),
                    const SizedBox(height: 15),
                    commonFilterChipWidget(
                      title: "Gender",
                      items: cubit.genders,
                      isSelected: (e) => cubit.tempSelectedGenders.contains(e),
                      onTap: (e) => cubit.toggleGender(e),
                      showDottedLine: false,
                    ),
                    const SizedBox(height: 25),
                    Row(
                      spacing: 15,
                      children: [
                        Flexible(
                          child: commonOutLineButtonView(
                            context: context,
                            buttonText: "Reset Filter",
                            onClicked: () => cubit.resetFilters(),
                          ),
                        ),
                        Flexible(
                          child: commonButtonView(
                            context: context,
                            buttonText: "Apply Filters",
                            onClicked: () => cubit.applyFilters(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget commonFilterChipWidget({
    required String title,
    required List<String> items,
    required bool Function(String) isSelected,
    required Function(String) onTap,
    bool showDottedLine = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(title: title, fontSize: 16, fontWeight: FontWeight.w600),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((e) {
            final selected = isSelected(e);

            return GestureDetector(
              onTap: () => onTap(e),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryColor : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? AppColors.primaryColor
                        : AppColors.dividerColor,
                  ),
                ),
                child: commonTitle(
                  title: e,
                  color: selected ? AppColors.white : AppColors.black,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
        ),
        if (showDottedLine) ...[const SizedBox(height: 20), commonDottedLine()],
      ],
    );
  }
}
