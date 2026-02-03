import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/user_model.dart';
import 'package:paw_pal_mobile/services/firestore_service.dart';

import '../../core/constant.dart';
import '../../model/city_model.dart';
import '../../model/state_model.dart';
import '../../services/api_service.dart';
import '../../services/image_upload_service.dart';
import '../../utils/widget_helper.dart';

part 'my_account_state.dart';

class MyAccountCubit extends Cubit<MyAccountState> {
  MyAccountCubit() : super(MyAccountInitial());

  UserModel? userModel;
  final fireStore = FireStoreService().fireStore;
  final ValueNotifier<File?> profileImageNotifier = ValueNotifier(null);
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final ValueNotifier<Gender?> genderNotifier = ValueNotifier<Gender?>(
    Gender.male,
  );
  final ImageUploadService imageService = ImageUploadService();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isEditLoading = ValueNotifier(false);
  TextEditingController addressController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  final List<StateModel> states = [];
  final List<CityModel> cities = [];

  final ValueNotifier<StateModel?> selectedStateNotifier = ValueNotifier(null);
  final ValueNotifier<CityModel?> selectedCityNotifier = ValueNotifier(null);
  final ValueNotifier<bool> isCityLoading = ValueNotifier(false);

  final ApiService apiService = ApiService();

  Future<void> loadMyAccount() async {
    emit(LoadMyAccountState());
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) {
        return;
      }

      final doc = await fireStore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        throw Exception("User data not found");
      }
      userModel = UserModel.fromMap(doc.data()!);
      emit(SuccessMyAccountState());
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      emit(ErrorMyAccountState(e.toString()));
    }
  }

  String getProfileImage() {
    return userModel?.profileImageUrl ?? "";
  }

  String getFullName() {
    return "$firstName $lastName";
  }

  String get firstName => userModel?.name ?? "";

  String get lastName => userModel?.lastName ?? "";

  String get getPhoneNumber =>
      CommonMethods().formatPhone(userModel?.phone ?? "");

  String getEmail() {
    return userModel?.email ?? "";
  }

  String getState() {
    return userModel?.state ?? "";
  }

  String getCity() {
    return userModel?.city.trim() ?? "";
  }

  String get getAddress => userModel?.address ?? "";

  Gender? get getGender {
    switch (userModel?.gender) {
      case AppStrings.male:
        return Gender.male;
      case AppStrings.female:
        return Gender.female;
      default:
        return null;
    }
  }

  void resetLocalPickImage() {
    profileImageNotifier.value = null;
  }

  void loadUserInformation() {
    firstNameController.text = firstName;
    lastNameController.text = lastName;
    emailController.text = getEmail();
    mobileController.text = getPhoneNumber;
    genderNotifier.value = getGender;
  }

  void updateMyAccount(BuildContext context) async {
    isLoading.value = true;
    try {
      if (isAllFiledValidated()) {
        final user = CommonMethods.getCurrentUser();
        if (user == null) {
          return;
        }
        String? profileImageUrl = getProfileImage();
        if (profileImageNotifier.value != null) {
          profileImageUrl = await imageService.uploadImage(
            image: profileImageNotifier.value!,
            uid: user.uid,
          );
        }
        final updateData = {
          'name': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'email': emailController.text.trim(),
          'gender': genderNotifier.value == Gender.male
              ? AppStrings.male
              : AppStrings.female,
          'profileImageUrl': profileImageUrl,
        };

        await fireStore.collection('users').doc(user.uid).update(updateData);
        await loadMyAccount();
        if (context.mounted) {
          context.pop();
        }
      }
    } catch (e) {
      debugPrint("Errorr :- ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStates() async {
    try {
      final result = await apiService.fetchStates();
      states
        ..clear()
        ..addAll(result);
      emit(SuccessMyAccountState());
    } catch (e) {
      debugPrint("State fetch error: $e");
    }
  }

  Future<void> fetchCities(String stateCode) async {
    isCityLoading.value = true;
    try {
      final result = await apiService.fetchCities(stateCode);
      cities
        ..clear()
        ..addAll(result);

      selectedCityNotifier.value = null;
    } catch (e) {
      debugPrint("City fetch error: $e");
    } finally {
      isCityLoading.value = false;
    }
  }

  bool isAllFiledValidated() {
    final name = firstNameController.text.trim();
    final email = emailController.text.trim();
    final lastName = lastNameController.text.trim();
    final commonMethod = CommonMethods();
    if (name.isEmpty) {
      commonMethod.showErrorToast("Please Enter Name");
      return false;
    } else if (!nameRegEx.hasMatch(name)) {
      commonMethod.showErrorToast("Please Enter Valid Name");
      return false;
    } else if (lastName.isEmpty) {
      commonMethod.showErrorToast("Please Enter Last Name");
      return false;
    } else if (!nameRegEx.hasMatch(lastName)) {
      commonMethod.showErrorToast("Please Enter Valid Last Name");
      return false;
    } else if (email.isEmpty) {
      commonMethod.showErrorToast("Please Enter Email");
      return false;
    } else if (!emailRegex.hasMatch(email)) {
      commonMethod.showErrorToast("Please Enter Valid Email");
      return false;
    }
    return true;
  }

  Future<void> loadAddressData() async {
    addressController.text = userModel?.address ?? "";
    pinCodeController.text = userModel?.pinCode ?? "";

    await fetchStates();

    if (userModel?.state != null) {
      final stateMatch = states.firstWhere(
        (e) => e.name == userModel!.state,
        orElse: () => StateModel(name: '', iso2: ''),
      );

      selectedStateNotifier.value = stateMatch;
      await fetchCities(stateMatch.iso2);
    }

    if (userModel?.city != null) {
      final cityMatch = cities.firstWhere(
        (e) => e.name == userModel!.city,
        orElse: () => CityModel(name: ''),
      );

      selectedCityNotifier.value = cityMatch;
    }

    emit(SuccessMyAccountState());
  }

  void selectState(StateModel val) {
    selectedStateNotifier.value = val;
    selectedCityNotifier.value = null;
    fetchCities(val.iso2);
  }

  void selectCity(CityModel val) {
    selectedCityNotifier.value = val;
  }

  void updateAddress(BuildContext context) async {
    isEditLoading.value = true;
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) {
        return;
      }
      final updateData = {
        'address': addressController.text.trim(),
        'city': selectedCityNotifier.value?.name,
        'state': selectedStateNotifier.value?.name,
        'pinCode': pinCodeController.text.trim(),
      };

      await fireStore.collection('users').doc(user.uid).update(updateData);
      await loadMyAccount();
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      debugPrint("Errorr :- ${e.toString()}");
    } finally {
      isEditLoading.value = false;
    }
  }

  void resetAddressFields() {
    addressController.text = userModel?.address ?? "";
    pinCodeController.text = userModel?.pinCode ?? "";

    if (userModel?.state != null) {
      final stateMatch = states.firstWhere(
            (e) => e.name == userModel!.state,
        orElse: () => StateModel(name: '', iso2: ''),
      );
      selectedStateNotifier.value = stateMatch;
    } else {
      selectedStateNotifier.value = null;
    }

    if (userModel?.city != null) {
      final cityMatch = cities.firstWhere(
            (e) => e.name == userModel!.city,
        orElse: () => CityModel(name: ''),
      );
      selectedCityNotifier.value = cityMatch;
    } else {
      selectedCityNotifier.value = null;
    }
  }

}
