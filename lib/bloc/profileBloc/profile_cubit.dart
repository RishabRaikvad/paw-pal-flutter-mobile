import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/model/user_model.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';

import '../../core/constant.dart';
import '../../services/image_upload_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  FirebaseAuthService authService = FirebaseAuthService();
  final ImageUploadService imageService = ImageUploadService();
  final ValueNotifier<Gender?> petGenderNotifier = ValueNotifier<Gender?>(
    Gender.male,
  );
  final ValueNotifier<File?> petMainImageNotifier = ValueNotifier(null);
  final ValueNotifier<File?> petOtherImage1Notifier = ValueNotifier(null);
  final ValueNotifier<File?> petOtherImage2Notifier = ValueNotifier(null);
  final ValueNotifier<File?> petOtherImage3Notifier = ValueNotifier(null);
  final ValueNotifier<File?> petOtherImage4Notifier = ValueNotifier(null);
  final ValueNotifier<File?> petDocumentImageNotifier = ValueNotifier(null);
  final ValueNotifier<HavePet?> petTypeNotifier = ValueNotifier<HavePet?>(
    HavePet.yes,
  );
  final ValueNotifier<File?> profileImageNotifier = ValueNotifier(null);
  final ValueNotifier<Gender?> genderNotifier = ValueNotifier<Gender?>(
    Gender.male,
  );

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController petNameController = TextEditingController();
  TextEditingController petTypeController = TextEditingController();
  TextEditingController petAgeController = TextEditingController();
  TextEditingController petBreadController = TextEditingController();

  Future<void> createUser(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint("❌ No authenticated user found");
        return;
      }
      final profileImage = await imageService.uploadImage(
        image: profileImageNotifier.value,
        uid: user.uid,
      );
      UserModel newUser = UserModel(
        uid: user.uid,
        name: firstNameController.text,
        lastName: lastNameController.text,
        phone: user.phoneNumber ?? "",
        email: emailController.text,
        gender: genderNotifier.value == Gender.male ? "Male" : "Female",
        isProfileCompleted: true,
        address: addressController.text,
        state: stateController.text,
        city: cityController.text,
        pinCode: pinCodeController.text,
        hasPet: petTypeNotifier.value == HavePet.yes ? true : false,
        createdAt: DateTime.now(),
        profileImageUrl: profileImage,
      );
      await authService.createUser(newUser);
      if(context.mounted){
        context.goNamed(Routes.homeScreen);
      }

    } catch (e) {
      debugPrint("Errror : ${e.toString()}");
    }
  }
}
