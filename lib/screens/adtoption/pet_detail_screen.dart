import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/bloc/adoptionBloc/adoption_cubit.dart';
import 'package:paw_pal_mobile/bloc/petDetailBloc/pet_detail_cubit.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/model/pet_model.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

import '../../core/AppColors.dart';
import '../../core/CommonMethods.dart';
import '../../model/pet_with_owner.dart';

class PetDetailScreen extends StatefulWidget {
  const PetDetailScreen({super.key});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  late PetDetailCubit cubit;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    cubit = context.read<PetDetailCubit>();
    pageController = PageController(initialPage: cubit.selectedImage);
  }

  @override
  void dispose() {
    cubit.resetData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: mainView());
  }

  Widget mainView() {
    return BlocBuilder<PetDetailCubit, PetDetailState>(
      builder: (context, state) {
        final model = cubit.model;
        if (model == null) return const SizedBox();

        return Stack(
          children: [
            petImageView(model.pet),

            DraggableScrollableSheet(
              initialChildSize: 0.48,
              minChildSize: 0.48,
              maxChildSize: 0.68,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: petDetailView(model),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget petDetailView(PetWithOwner model) {
    final pet = model.pet;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: commonTitle(
                  title: pet.name,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                ),
              ),
              commonTitle(
                title: CommonMethods().formatPrice(model.pet.petPrice),
                color: AppColors.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),

          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
                fontFamily: Constant.fontFamily,
              ),
              children: [
                TextSpan(text: pet.breed),
                TextSpan(
                  text: " • ",
                  style: const TextStyle(color: AppColors.primaryColor),
                ),
                TextSpan(text: pet.gender),
                TextSpan(
                  text: " • ",
                  style: const TextStyle(color: AppColors.primaryColor),
                ),
                TextSpan(text: pet.age),
              ],
            ),
          ),

          const SizedBox(height: 10),
          commonDottedLine(),
          const SizedBox(height: 10),

          commonTitle(
            title: "About Pet",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          commonTitle(
            title: pet.petDescription,
            color: AppColors.grey,
            fontSize: 14,
            textAlign: TextAlign.start,
          ),

          const SizedBox(height: 15),
          commonTitle(
            title: "Owner Details",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,

            decoration: BoxDecoration(
              color: AppColors.inputBgColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      ClipOval(
                        child: commonNetworkImage(
                          imageUrl: model.ownerImage,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonTitle(
                              title:
                                  "Hello,${model.ownerName} ${model.ownerLastName}",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            commonTitle(
                              title: model.ownerEmail,
                              fontSize: 12,
                              color: AppColors.grey,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          CommonMethods.call(
                            CommonMethods().formatPhone(model.ownerPhone),
                          );
                        },
                        child: SvgPicture.asset(AppImages.icNeedHelp),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: commonDottedLine(),
                  ),
                  const SizedBox(height: 15),
                  commonTitle(
                    title: "Address",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  commonTitle(
                    title: cubit.getOwnerAddress(model),
                    color: AppColors.grey,
                    fontSize: 14,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              context.read<AdoptionCubit>().navigateAdoptionFormScreen(
                context,
                model,
              );
            },
            child: SvgPicture.asset(AppImages.icAdoptMeBtn),
          ),
        ],
      ),
    );
  }

  Widget petImageView(PetModel pet) {
    final images = pet.getAllImages;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              cubit.changeImage(index);
            },
            itemBuilder: (context, index) {
              return commonNetworkImage(
                imageUrl: images[index],
                width: double.infinity,
                fit: BoxFit.fill,
              );
            },
          ),
          Positioned(
            bottom: 80,
            left: 5,
            right: 0,
            child: SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  final isSelected = cubit.selectedImage == index;

                  return GestureDetector(
                    onTap: () {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      cubit.changeImage(index);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : AppColors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: commonNetworkImage(
                          imageUrl: images[index],
                          width: 50,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
