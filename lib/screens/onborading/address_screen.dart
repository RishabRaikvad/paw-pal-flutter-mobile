import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/bloc/profileBloc/profile_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool loading = false;
  late ProfileCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = context.read<ProfileCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GradientBackground(child: mainView()));
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              commonBack(context),
              SizedBox(height: 30),
              commonTitle(
                title: AppStrings.whereAreYouLocated,
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
              SizedBox(height: 8),
              commonTitle(
                title: AppStrings.thisHelpsUs,
                color: AppColors.grey,
                fontSize: 14,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 30),
              buildFormView(),
              SizedBox(height: 20),
              commonDottedLine(),
              SizedBox(height: 20),
              commonTitle(
                title: "Do you have a pet?",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              havePetView(),
              SizedBox(height: 20),
              ValueListenableBuilder<HavePet?>(
                valueListenable: cubit.petTypeNotifier,
                builder: (context, value, _) {
                  return commonButtonView(
                    context: context,
                    isLoading: loading,
                    buttonText: value == HavePet.yes
                        ? AppStrings.continueText
                        : AppStrings.save,
                    onClicked: () async {
                      if (value == HavePet.yes) {
                        context.pushNamed(Routes.petProfileScreen);
                      } else {
                        setState(() {
                          loading = true;
                        });
                        await Future.delayed(Duration(seconds: 3));
                        if (context.mounted) {
                          await cubit.createUser(context);
                        }
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18,
      children: [
        commonTextFieldWithLabel(
          label: "Address",
          hint: "Enter Your Address",
          context: context,
          inputType: TextInputType.streetAddress,
          maxLines: 4,
          controller: cubit.addressController,
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: commonTextFieldWithLabel(
                label: "City",
                hint: "Enter City",
                context: context,
                maxLines: 1,
                controller: cubit.cityController,
              ),
            ),
            Expanded(
              child: commonTextFieldWithLabel(
                label: "Postal Code",
                hint: "Enter Postal Code",
                context: context,
                maxLines: 1,
                controller: cubit.pinCodeController,
              ),
            ),
          ],
        ),
        commonTextFieldWithLabel(
          label: "State",
          hint: "Enter State",
          context: context,
          textInputAction: TextInputAction.done,
          controller: cubit.stateController,
        ),
      ],
    );
  }

  Widget _genderTile({
    required String title,
    required HavePet value,
    required HavePet? selectedPetType,
  }) {
    return GestureDetector(
      onTap: () => cubit.petTypeNotifier.value = value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<HavePet>(
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
          commonTitle(title: title, fontSize: 12, color: AppColors.grey),
        ],
      ),
    );
  }

  Widget havePetView() {
    return ValueListenableBuilder<HavePet?>(
      valueListenable: cubit.petTypeNotifier,
      builder: (context, selectedPetType, _) {
        return RadioGroup<HavePet>(
          groupValue: selectedPetType,
          onChanged: (value) {
            cubit.petTypeNotifier.value = value;
          },
          child: Row(
            children: [
              _genderTile(
                title: "Yes, I have a pet",
                value: HavePet.yes,
                selectedPetType: selectedPetType,
              ),
              const SizedBox(width: 16),
              _genderTile(
                title: "No, not right now",
                value: HavePet.no,
                selectedPetType: selectedPetType,
              ),
            ],
          ),
        );
      },
    );
  }
}
