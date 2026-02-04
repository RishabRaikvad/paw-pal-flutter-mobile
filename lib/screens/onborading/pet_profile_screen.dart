import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/ui_helper.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../bloc/profileBloc/profile_cubit.dart';
import '../../core/CommonMethods.dart';
import '../../utils/dialog_utils.dart';

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  final ValueNotifier<int> currentStep = ValueNotifier<int>(0);
  late final List<Widget> steps;
  late ProfileCubit cubit;
  late Razorpay razorpay;
  String phone = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    init();
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
            const   SizedBox(height: 25),
            commonBack(context),
            const  SizedBox(height: 10),
            stepperView(),
            const  SizedBox(height: 10),
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
                        if (step > 0) const  SizedBox(width: 10),
                        Expanded(
                          child: commonButtonView(
                            context: context,
                            buttonText: step == steps.length - 1
                                ? AppStrings.finishSetup
                                : AppStrings.next,

                            onClicked: () async {
                              if (currentStep.value < steps.length - 1) {
                                currentStep.value++;
                              } else {
                                openPaymentDialog();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const  SizedBox(height: 20),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
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
        const  SizedBox(height: 8),
        commonTitle(
          title: AppStrings.fillFewDetails,
          color: AppColors.grey,
          fontSize: 14,
          textAlign: TextAlign.start,
        ),
        const  SizedBox(height: 50),
        commonTextFieldWithLabel(
          label: AppStrings.petName,
          hint: AppStrings.enterPetName,
          context: context,
          controller: cubit.petNameController,
        ),
       const  SizedBox(height: 18),
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
          ],
        ),
        const  SizedBox(height: 18),
        commonTitle(title: AppStrings.age, fontSize: 14, color: AppColors.grey),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.inputBgColor.withValues(alpha: 0.1),
                ),
                child: ValueListenableBuilder<int?>(
                  valueListenable: cubit.selectedPetYearsNotifier,
                  builder: (context, selectedYear, _) {
                    return DropdownButton<int>(
                      hint: const Text(AppStrings.year),
                      value: selectedYear,
                      isExpanded: true,
                      underline: const  SizedBox.shrink(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: List.generate(21, (i) => i)
                          .map(
                            (y) => DropdownMenuItem<int>(
                              value: y,
                              child: Text(
                                "$y",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        cubit.selectedPetYearsNotifier.value = val;

                      },
                    );
                  },
                ),
              ),
            ),

            const  SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.inputBgColor.withValues(alpha: 0.1),
                ),
                child: ValueListenableBuilder<int?>(
                  valueListenable: cubit.selectedPetMonthsNotifier,
                  builder: (context, selectedMonth, _) {
                    return DropdownButton<int>(
                      hint: const Text(AppStrings.month),
                      value: selectedMonth,
                      isExpanded: true,
                      underline: const  SizedBox.shrink(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: List.generate(13, (i) => i)
                          .map(
                            (m) => DropdownMenuItem<int>(
                              value: m,
                              child: Text(
                                "$m",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val == null) return;
                        cubit.handlePetMonthChange(val);
                      },

                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        commonTextFieldWithLabel(
          label: AppStrings.breedName,
          hint: AppStrings.enterBreedName,
          context: context,
          controller: cubit.petBreadController,
        ),
        const SizedBox(height: 18),
        commonTextFieldWithLabel(
          label: AppStrings.aboutPet,
          hint: AppStrings.petDescription,
          context: context,
          controller: cubit.petDescriptionController,
          maxLines: 3,
          maxLength: 150
        ),
        const SizedBox(height: 18),
        commonTitle(
          title: AppStrings.gender,
          fontSize: 14,
          color: AppColors.grey,
        ),
        genderRadioButtons(),
        const SizedBox(height: 18),
        commonTextFieldWithLabel(
          label: AppStrings.adoptionPrice,
          hint: AppStrings.enterPrice,
          context: context,
          controller: cubit.petPriceController,
          maxLength: 8,
          inputType: TextInputType.number,
          inputFormatter: [FilteringTextInputFormatter.digitsOnly]
        ),

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
        const SizedBox(height: 8),
        commonTitle(
          title: AppStrings.uploadPetPhotosDesc,
          color: AppColors.grey,
          fontSize: 14,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 50),
        uploadMainPetImageView(),
        const SizedBox(height: 20),
        commonDottedLine(),
        const SizedBox(height: 20),
        commonTitle(title: AppStrings.otherImageTitle),
        const SizedBox(height: 10),
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
        const SizedBox(height: 8),
        commonTitle(
          title: AppStrings.uploadDocumentsDesc,
          color: AppColors.grey,
          fontSize: 14,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 50),
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
            const SizedBox(width: 8),
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
              const  SizedBox(width: 16),
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
        const SizedBox(height: 10),
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
        const SizedBox(height: 10),
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
              child:  SizedBox(
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

  void openPaymentDialog() {
    DialogUtils.openBottomSheetDialog(
      context: context,
      contentWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          commonTitle(
            title: AppStrings.paymentBottomSheetTitle,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.start,
          ),
          const  SizedBox(height: 5),
          commonTitle(
            title:AppStrings.paymentBottomSubSheetTitle,
            fontSize: 13,
            textAlign: TextAlign.start,
            color: AppColors.grey,
          ),
          const  SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.petDetailBgColor,
              border: Border.all(
                color: AppColors.grey.withValues(alpha: 0.1),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 15,
              ),
              child: Row(
                children: [
                  ValueListenableBuilder<File?>(
                    valueListenable: cubit.petMainImageNotifier,
                    builder: (context, imageFile, _) {
                      return Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: AppColors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: imageFile != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const Icon(
                          Icons.pets,
                          color: Colors.white,
                          size: 28,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            Flexible(
                              child: commonTitle(
                                title: cubit.petNameController.text,
                                fontWeight: FontWeight.w600,
                                maxLines: 1,
                                overFlow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Flexible(
                              child: commonTitle(
                                title: "(${cubit.petBreadController.text})",
                                maxLines: 1,
                                overFlow: TextOverflow.ellipsis,
                                color: AppColors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          spacing: 5,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ValueListenableBuilder<Gender?>(
                              valueListenable: cubit.petGenderNotifier,
                              builder: (context, gender, _) {
                                return commonTitle(
                                  title: cubit.getGenderText(gender),
                                  fontSize: 12,
                                );
                              },
                            ),
                            CircleAvatar(
                              radius: 3,
                              backgroundColor: AppColors.grey,
                            ),
                          ],
                        ),
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            cubit.selectedPetYearsNotifier,
                            cubit.selectedPetMonthsNotifier,
                          ]),
                          builder: (context, _) {
                            return commonTitle(
                              title: "${cubit.petAge} ${AppStrings.old}",
                              fontSize: 12,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      commonTitle(
                        title: CommonMethods().formatPrice(cubit.getAdoptionPrice),
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      commonTitle(
                        title: AppStrings.adoptionPrice,
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          commonButtonView(
            context: context,
            buttonText: AppStrings.paymentFess,
            onClicked: () async {
              openRazorpay();
              context.pop();
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (response.paymentId == null || response.paymentId!.isEmpty) {
      // Probably user dismissed or invalid payment
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment not completed. Please try again."),
        ),
      );
      return; // Stop here
    }
    cubit.generatePetId();
    final success = await cubit.createPetCreateFess(
      "Success",
      response.paymentId ?? "",
    );
    if (!success) {
      return;
    }
    if (cubit.addMorePet) {
      final isAdd = await cubit.createPet();
      if (isAdd && mounted) {
        context.goNamed(Routes.dashBoardScreen);
      }
      return;
    } else {
      if (mounted) {
        cubit.createUser(context);
      }
    }
  }

  void openRazorpay() {
    var options = {
      'key': Constant.razorPayKey,
      'amount': 1 * 100,
      'currency': 'INR',
      'name': 'Paw Pal',
      'description': 'Pet Creation Fee',
      'prefill': {'contact': phone, 'email': email},
      'theme': {'color': '#FD6C02'},
    };
    try {
      options.forEach((key, value) {
        debugPrint("Option Data: $key => $value");
      });
      razorpay.open(options);
    } catch (e) {
      debugPrint("Razorpay Error: $e");
    }
  }

  void _handlePaymentError(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Payment failed. Try again")));
  }

  void init() {
    cubit = context.read<ProfileCubit>();
    steps = [petInfoStep(), uploadPhotosStep(), uploadDocumentsStep()];
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = CommonMethods.getCurrentUser();

    if (user != null) {
      phone = CommonMethods().formatPhone(user.phoneNumber);

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      if (doc.exists) {
        email = doc.data()?['email'] ?? "";
      }

      if (email.isEmpty) {
        email = cubit.emailController.text.trim();
      }
    }

    debugPrint("User Data :- Phone: $phone, Email: $email");
  }
}
