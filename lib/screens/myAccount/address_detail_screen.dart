import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/bloc/myAccountBloc/my_account_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/dialog_utils.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

import '../../model/city_model.dart';
import '../../model/state_model.dart';

class AddressDetailScreen extends StatefulWidget {
  const AddressDetailScreen({super.key});

  @override
  State<AddressDetailScreen> createState() => _AddressDetailScreenState();
}

class _AddressDetailScreenState extends State<AddressDetailScreen> {
  late MyAccountCubit cubit;

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
            const SizedBox(height: 20),
            commonBackWithHeader(
              context: context,
              title: AppStrings.addressDetail,
              isShowTitle: true,
            ),
            const SizedBox(height: 30),
            commonTitle(
              title: AppStrings.manageAddressDetail,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            commonTitle(
              title: AppStrings.manageAddressDetailSubTitle,
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 15),
            addressView(),
          ],
        ),
      ),
    );
  }

  Widget addressView() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBgColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                commonTitle(title: AppStrings.editAddress, fontSize: 14),
                InkResponse(
                  onTap: () {
                    editAddressBottomSheet();
                  },
                  child: SvgPicture.asset(AppImages.icEdit),
                ),
              ],
            ),
            const SizedBox(height: 5),
            commonDottedLine(),
            const SizedBox(height: 3),
            Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(AppImages.icAddress),
                Flexible(
                  child: BlocBuilder<MyAccountCubit, MyAccountState>(
                    builder: (context, state) {
                      return commonTitle(
                        title: cubit.getAddress,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.start,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void editAddressBottomSheet() {
    cubit.resetAddressFields();
    DialogUtils.openBottomSheetDialog(
      context: context,
      isScrollControlled: true,
      contentWidget: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = MediaQuery.of(context).size.height * 0.85;
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    commonTitle(
                      title: AppStrings.editYourAddress,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                    commonTitle(
                      title: AppStrings.updatePrimaryAddress,
                      color: AppColors.grey,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                    commonTextFieldWithLabel(
                      label: AppStrings.address,
                      hint: AppStrings.enterYourAddress,
                      context: context,
                      inputType: TextInputType.streetAddress,
                      maxLines: 4,
                      controller: cubit.addressController,
                    ),
                    const SizedBox(height: 10),
                    commonTitle(
                      title: AppStrings.state,
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                    const SizedBox(height: 3),
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
                            hint: const Text(AppStrings.selectState),
                            value: selectedState?.iso2,
                            isExpanded: true,
                            underline: const SizedBox.shrink(),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: cubit.states.map((state) {
                              return DropdownMenuItem<String>(
                                value: state.iso2,
                                child: Text(
                                  state.name,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (newIso2) {
                              if (newIso2 == null) return;
                              final state = cubit.states.firstWhere(
                                (s) => s.iso2 == newIso2,
                              );
                              cubit.selectState(state);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    commonTitle(
                      title: AppStrings.city,
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.inputBgColor.withValues(alpha: 0.1),
                      ),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: cubit.isCityLoading,
                        builder: (context, loading, _) {
                          if (loading) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: const Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            );
                          } else {
                            return ValueListenableBuilder<CityModel?>(
                              valueListenable: cubit.selectedCityNotifier,
                              builder: (context, selectedCity, _) {
                                return DropdownButton<String>(
                                  hint: const Text(AppStrings.selectCity),
                                  value: selectedCity?.name,
                                  underline: const SizedBox.shrink(),
                                  isExpanded: true,
                                  items: cubit.cities.map((city) {
                                    return DropdownMenuItem<String>(
                                      value: city.name,
                                      child: Text(city.name),
                                    );
                                  }).toList(),
                                  onChanged: (newName) {
                                    if (newName == null) return;
                                    final city = cubit.cities.firstWhere(
                                      (c) => c.name == newName,
                                    );
                                    cubit.selectCity(city);
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    commonTextFieldWithLabel(
                      label: AppStrings.postalCode,
                      hint: AppStrings.enterPostalCode,
                      context: context,
                      maxLines: 1,
                      controller: cubit.pinCodeController,
                      inputType: TextInputType.number,
                      maxLength: 5,
                      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      spacing: 10,
                      children: [
                        Flexible(
                          child: commonOutLineButtonView(
                            context: context,
                            buttonText: AppStrings.cancel,
                            onClicked: () {
                              cubit.resetAddressFields();
                              context.pop();
                            },
                          ),
                        ),
                        Flexible(
                          child: ValueListenableBuilder(
                            valueListenable: cubit.isEditLoading,
                            builder: (context, value, child) {
                              return commonButtonView(
                                context: context,
                                buttonText: AppStrings.saveAddress,
                                isLoading: value,
                                onClicked: () {
                                  cubit.updateAddress(context);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void init() {
    cubit = context.read<MyAccountCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await cubit.loadAddressData();
    });
  }
}
