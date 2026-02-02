import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';

import '../../bloc/myAccountBloc/my_account_cubit.dart';
import '../../core/AppImages.dart';
import '../../core/AppStrings.dart';
import '../../core/CommonMethods.dart';
import '../../core/constant.dart';
import '../../utils/widget_helper.dart';

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({super.key});

  @override
  State<AccountInformationScreen> createState() =>
      _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  late MyAccountCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<MyAccountCubit>();
    cubit.loadMyAccount();
    cubit.loadUserInformation();
  }

  @override
  void dispose() {
    cubit.resetLocalPickImage();
    super.dispose();
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
            commonBackWithHeader(
              context: context,
              title: AppStrings.accountInformation,
              isShowTitle: true,
            ),
            const SizedBox(height: 20),
            commonTitle(
              title: AppStrings.updateProfileTitle,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 5),
            commonTitle(
              title:
                 AppStrings.updateProfileDesc,
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<MyAccountCubit, MyAccountState>(
                builder: (context, state) {
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: updateProfileView()),
                      SliverToBoxAdapter(child: const SizedBox(height: 30)),
                      SliverToBoxAdapter(child: buildFormWidget()),
                      SliverToBoxAdapter(child: const SizedBox(height: 18)),
                      SliverToBoxAdapter(
                        child: commonTitle(
                          title: AppStrings.gender,
                          fontSize: 14,
                          color: AppColors.grey,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SliverToBoxAdapter(child: genderRadioButtons()),
                      SliverToBoxAdapter(child: const SizedBox(height: 20)),
                      SliverToBoxAdapter(
                        child: ValueListenableBuilder(
                          valueListenable: cubit.isLoading,
                          builder: (context, isLoading, child) {
                            return commonButtonView(
                              context: context,
                              buttonText: AppStrings.updateProfileButton,
                              isLoading: isLoading,
                              onClicked: () {
                                cubit.updateMyAccount(context);
                              },
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(child: const SizedBox(height: 20)),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget updateProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            final image = await CommonMethods.pickAndCompressImage(
              context: context,
            );

            if (image != null) {
              cubit.profileImageNotifier.value = image;
            }
          },
          child: ValueListenableBuilder<File?>(
            valueListenable: cubit.profileImageNotifier,
            builder: (context, image, _) {
              if (image != null) {
                return CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(image),
                );
              }

              final profileUrl = cubit.getProfileImage();
              if (profileUrl.isNotEmpty) {
                return ClipOval(
                  child: commonNetworkImage(
                    imageUrl: profileUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              }

              return SvgPicture.asset(AppImages.icUploadProfile);
            },
          ),
        ),
        const SizedBox(height: 8),
        commonTitle(
          title: AppStrings.updateProfilePhoto,
          color: AppColors.grey,
          fontSize: 16,
        ),
      ],
    );
  }

  Widget buildFormWidget() {
    return Column(
      spacing: 18,
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: commonTextFieldWithLabel(
                label: AppStrings.firstName,
                hint: AppStrings.enterFirstName,
                context: context,
                maxLines: 1,
                controller: cubit.firstNameController,
              ),
            ),
            Expanded(
              child: commonTextFieldWithLabel(
                label: AppStrings.lastName,
                hint: AppStrings.enterLastName,
                context: context,
                maxLines: 1,
                controller: cubit.lastNameController,
              ),
            ),
          ],
        ),
        commonTextFieldWithLabel(
          label: AppStrings.email,
          hint: AppStrings.enterEmailAddress,
          context: context,
          inputType: TextInputType.emailAddress,
          controller: cubit.emailController,
        ),
        commonTextFieldWithLabel(
          label: AppStrings.mobileNumber,
          hint: AppStrings.enterMobileNumber,
          context: context,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: commonTitle(title: AppStrings.countryCode),
          ),
          readOnly: true,
          inputType: TextInputType.phone,
          maxLength: 10,
          inputFormatter: [FilteringTextInputFormatter.digitsOnly],
          controller: cubit.mobileController,
        ),
      ],
    );
  }

  Widget _genderTile({
    required String title,
    required Gender value,
    required Gender? selectedGender,
  }) {
    return GestureDetector(
      onTap: () => cubit.genderNotifier.value = value,
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
      valueListenable: cubit.genderNotifier,
      builder: (context, selectedGender, _) {
        return RadioGroup<Gender>(
          groupValue: selectedGender,
          onChanged: (value) {
            cubit.genderNotifier.value = value;
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
}
