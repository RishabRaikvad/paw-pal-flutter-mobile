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
}
