
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/ui_helper.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

import '../../bloc/profileBloc/profile_cubit.dart';

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  final ValueNotifier<int> currentStep = ValueNotifier<int>(0);
  late final List<Widget> steps;
  late ProfileCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<ProfileCubit>();
    steps = [petInfoStep(), uploadPhotosStep(), uploadDocumentsStep()];
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
            SizedBox(height: 25),
            commonBack(context),
            SizedBox(height: 10),
            stepperView(),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: ValueListenableBuilder<int>(
                  valueListenable: currentStep,
                  builder: (_, step, __) {
                    return Column(
                      children: [
                        steps[step],
                        SizedBox(height: UIHelper.screenHeight(context) * 0.2),
                      ],
                    );
                  },
                ),
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: currentStep,
              builder: (_, step, __) {
                return Column(
                  children: [
                    Row(
                      children: [
                        if (step > 0)
                          Expanded(
                            child: commonOutLineButtonView(
                              context: context,
                              buttonText: AppStrings.back,
                              onClicked: () {
                                currentStep.value--;
                              },
                            ),
                          ),
                        if (step > 0) const SizedBox(width: 10),
                        Expanded(
                          child: commonButtonView(
                            context: context,
                            buttonText: step == steps.length - 1
                                ? AppStrings.finishSetup
                                : AppStrings.next,

                            onClicked: () {
                              if (currentStep.value < steps.length - 1) {
                                currentStep.value++;
                              } else {
                                cubit.createUser(context);
                                // Finish setup
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget petInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: AppStrings.furryFriend,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        SizedBox(height: 8),
        commonTitle(
          title: AppStrings.fillFewDetails,
          color: AppColors.grey,
          fontSize: 14,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 50),
        commonTextFieldWithLabel(
          label: AppStrings.petName,
          hint: AppStrings.enterPetName,
          context: context,
          controller: cubit.petNameController,
        ),
        SizedBox(height: 18),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: commonTextFieldWithLabel(
                label: AppStrings.petType,
                hint: AppStrings.enterPetType,
                context: context,
                maxLines: 1,
                controller: cubit.petTypeController,
              ),
            ),
            Expanded(
              child: commonTextFieldWithLabel(
                label: AppStrings.age,
                hint: AppStrings.enterAge,
                context: context,
                controller: cubit.petAgeController,
              ),
            ),
          ],
        ),
        SizedBox(height: 18),
        commonTextFieldWithLabel(
          label: AppStrings.breedName,
          hint: AppStrings.enterBreedName,
          context: context,
          controller: cubit.petBreadController,
        ),
        SizedBox(height: 18),
        commonTitle(
          title: AppStrings.gender,
          fontSize: 14,
          color: AppColors.grey,
        ),
        genderRadioButtons(),
      ],
    );
  }

  Widget uploadPhotosStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        commonTitle(
          title: AppStrings.seeThosePaws,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        SizedBox(height: 8),
        commonTitle(
          title: AppStrings.uploadPetPhotosDesc,
          color: AppColors.grey,
          fontSize: 14,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 50),
        uploadMainPetImageView(),
        SizedBox(height: 20),
        commonDottedLine(),
        SizedBox(height: 20),
        commonTitle(title: "Other Images Title"),
        SizedBox(height: 10),
        uploadPetOtherImgView(),
      ],
    );
  }

  Widget uploadDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: AppStrings.keepRecordsSafe,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        SizedBox(height: 8),
        commonTitle(
          title: AppStrings.uploadDocumentsDesc,
          color: AppColors.grey,
          fontSize: 14,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 50),
        uploadPetDocumentImageView(),
      ],
    );
  }

  Widget stepperView() {
    return ValueListenableBuilder<int>(
      valueListenable: currentStep,
      builder: (_, step, __) {
        return Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: (step + 1) / steps.length,
                minHeight: 6,
                backgroundColor: AppColors.dividerColor,
                color: AppColors.primaryColor,
                borderRadius: BorderRadiusGeometry.circular(30),
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: commonTitle(
                title: '${step + 1}/${steps.length}',
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _genderTile({
    required String title,
    required Gender value,
    required Gender? selectedGender,
  }) {
    return GestureDetector(
      onTap: () => cubit.petGenderNotifier.value = value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<Gender>(
            value: value,
            fillColor: WidgetStateProperty.resolveWith(
              (states) => AppColors.primaryColor,
            ),
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (!states.contains(WidgetState.selected)) {
                return AppColors.plashHolderColor.withValues(alpha: 0.1);
              }
              return AppColors.primaryColor.withValues(alpha: 0.1);
            }),
          ),
          commonTitle(title: title, fontSize: 14, color: AppColors.grey),
        ],
      ),
    );
  }

  Widget genderRadioButtons() {
    return ValueListenableBuilder<Gender?>(
      valueListenable: cubit.petGenderNotifier,
      builder: (context, selectedGender, _) {
        return RadioGroup<Gender>(
          groupValue: selectedGender,
          onChanged: (value) {
            cubit.petGenderNotifier.value = value;
          },
          child: Row(
            children: [
              _genderTile(
                title: AppStrings.male,
                value: Gender.male,
                selectedGender: selectedGender,
              ),
              const SizedBox(width: 16),
              _genderTile(
                title: AppStrings.female,
                value: Gender.female,
                selectedGender: selectedGender,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget uploadMainPetImageView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(title: AppStrings.uploadMainImage),
        SizedBox(height: 10),
        uploadImageView(
          context: context,
          uploadedImage: cubit.petMainImageNotifier,
          image: AppImages.icMainPet,
          height: 200,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget uploadPetDocumentImageView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(title: AppStrings.vaccinationCertificates),
        SizedBox(height: 10),
        uploadImageView(
          context: context,
          uploadedImage: cubit.petDocumentImageNotifier,
          image: AppImages.icPetDoc,
          height: 200,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget uploadPetOtherImgView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        const itemCount = 4;

        final totalSpacing = spacing * (itemCount - 1);
        final itemSize = (constraints.maxWidth - totalSpacing) / itemCount;

        return Row(
          children: List.generate(itemCount, (index) {
            final notifier = [
              cubit.petOtherImage1Notifier,
              cubit.petOtherImage2Notifier,
              cubit.petOtherImage3Notifier,
              cubit.petOtherImage4Notifier,
            ][index];

            return Padding(
              padding: EdgeInsets.only(
                right: index == itemCount - 1 ? 0 : spacing,
              ),
              child: SizedBox(
                width: itemSize,
                height: itemSize,
                child: uploadImageView(
                  context: context,
                  uploadedImage: notifier,
                  image: AppImages.icPetOther,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
