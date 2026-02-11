import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/bloc/petCubit/pet_cubit.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
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
                  return RefreshIndicator(
                    onRefresh: loadPetData,
                    child: CustomScrollView(slivers: [buildPetView()]),
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
            title: "Search pets, products & care..."
          ),
        ),
        SvgPicture.asset(AppImages.icFilter, height: 50, width: 50),
      ],
    );
  }

  SliverGrid buildPetView() {
    final petCount = cubit.petList.length;
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 14,
        childAspectRatio: 0.75,
        //mainAxisExtent: 220,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final pet = cubit.petList[index];
        return commonPetCard(
          petName: pet.pet.name,
          petBread: pet.pet.breed,
          img: pet.pet.mainImageUrl ?? "",
          price: pet.pet.petPrice,
        );
      }, childCount: petCount),
    );
  }

  Widget petLoadView() {
    return CustomScrollView(slivers: [shimmerGrid(count: 6)]);
  }
}
