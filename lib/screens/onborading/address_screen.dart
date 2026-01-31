import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/bloc/profileBloc/profile_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

import '../../core/CommonMethods.dart';
import '../../model/city_model.dart';
import '../../model/state_model.dart';
import 'package:flutter/cupertino.dart';

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
    cubit.fetchStates();
  }
@override
  void dispose() {
    cubit.resetAddressData();
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              commonBackWithHeader(context: context),
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
                      if (isAllFiledValidated()) {
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
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonTitle(
                        title: "State",
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.inputBgColor.withValues(alpha: 0.1),
                        ),
                        child: ValueListenableBuilder<StateModel?>(
                          valueListenable: cubit.selectedStateNotifier,
                          builder: (context, selectedState, _) {
                            return DropdownButton<String>(
                              hint: const Text("Select State"),
                              value: selectedState?.iso2,
                              isExpanded: true,
                              underline: SizedBox.shrink(),
                              items: cubit.states.map((state) {
                                return DropdownMenuItem<String>(
                                  value: state.iso2,
                                  child: Text(state.name),
                                );
                              }).toList(),
                              onChanged: (newIso2) {
                                if (newIso2 == null) return;
                                final state =
                                cubit.states.firstWhere((s) => s.iso2 == newIso2);
                                cubit.selectState(state);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: commonTextFieldWithLabel(
                    label: "Postal Code",
                    hint: "Enter Postal Code",
                    context: context,
                    maxLines: 1,
                    controller: cubit.pinCodeController,
                    inputType: TextInputType.number,
                    maxLength: 5,
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonTitle(title: "City", fontSize: 14, color: AppColors.grey),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.inputBgColor.withValues(alpha: 0.1),
                  ),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: cubit.isCityLoading,
                    builder: (context, loading, _) {
                      if (loading) {
                        return  Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(child: CupertinoActivityIndicator()),
                        );
                      } else {
                        return ValueListenableBuilder<CityModel?>(
                          valueListenable: cubit.selectedCityNotifier,
                          builder: (context, selectedCity, _) {
                            return DropdownButton<String>(
                              hint: const Text("Select City"),
                              value: selectedCity?.name,
                              underline: SizedBox.shrink(),
                              isExpanded: true,
                              items: cubit.cities.map((city) {
                                return DropdownMenuItem<String>(
                                  value: city.name,
                                  child: Text(city.name),
                                );
                              }).toList(),
                              onChanged: (newName) {
                                if (newName == null) return;
                                final city = cubit.cities.firstWhere((c) => c.name == newName);
                                cubit.selectCity(city);
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            )

          ],
        );
      },
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

  bool isAllFiledValidated() {
    final address = cubit.addressController.text.trim();
    final city = cubit.cityController.text.trim();
    final state = cubit.stateController.text.trim();
    final postalCode = cubit.pinCodeController.text.trim();
    final commonMethod = CommonMethods();
    if (address.isEmpty) {
      commonMethod.showErrorToast("Please Enter Address");
      return false;
    } else if (city.isEmpty) {
      commonMethod.showErrorToast("Please Enter City");
      return false;
    } else if (!nameRegEx.hasMatch(city)) {
      commonMethod.showErrorToast("Please Enter Valid City");
      return false;
    } else if (postalCode.isEmpty) {
      commonMethod.showErrorToast("Please Enter Postal Code");
      return false;
    } else if (state.isEmpty) {
      commonMethod.showErrorToast("Please Enter State");
      return false;
    } else if (!nameRegEx.hasMatch(state)) {
      commonMethod.showErrorToast("Please Enter Valid State");
      return false;
    }

    return true;
  }
}
