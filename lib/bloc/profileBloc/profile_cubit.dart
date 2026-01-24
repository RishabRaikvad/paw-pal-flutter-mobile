import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/user_model.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';

import '../../core/constant.dart';
import '../../model/pet_model.dart';
import '../../services/image_upload_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  FirebaseAuthService authService = FirebaseAuthService();
  final ImageUploadService imageService = ImageUploadService();
  final ValueNotifier<Gender?> petGenderNotifier = ValueNotifier<Gender?>(
    Gender.male,
  );
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

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
  TextEditingController mobileController = TextEditingController();

  bool addMorePet = false;

  Future<void> createUser(BuildContext context) async {
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return;

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
      if (petTypeNotifier.value == HavePet.yes) {
       await createPet();
      }
      if (context.mounted) {
        context.goNamed(Routes.dashBoardScreen);
      }
    } catch (e) {
      debugPrint("Errror : ${e.toString()}");
    }
  }

  Future<bool> createPet() async {
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return false;
      final petMainImage = await imageService.uploadImage(
        image: petMainImageNotifier.value,
        uid: user.uid,
      );
      final petDocumentImage = await imageService.uploadImage(
        image: petDocumentImageNotifier.value,
        uid: user.uid,
      );
      final List<String> otherImageUrls = [];

      final images = [
        petOtherImage1Notifier.value,
        petOtherImage2Notifier.value,
        petOtherImage3Notifier.value,
        petOtherImage4Notifier.value,
      ];

      for (final image in images) {
        if (image != null) {
          final url = await imageService.uploadImage(
            image: image,
            uid: user.uid,
          );
          if (url != null) {
            otherImageUrls.add(url);
          }
        }
      }
      final petId = fireStore.collection("pets").doc().id;
      final pet = PetModel(
        id: petId,
        ownerId: user.uid,
        name: petNameController.text,
        type: petTypeController.text,
        breed: petBreadController.text,
        age: int.tryParse(petAgeController.text) ?? 0,
        gender: petGenderNotifier.value == Gender.male ? "Male" : "Female",
        mainImageUrl: petMainImage,
        otherImageUrls: otherImageUrls,
        vaccinationCertificateUrl: petDocumentImage,
        createdAt: DateTime.now(),
        isAdopted: false,
      );
      await authService.createPet(pet);
      final userRef = fireStore.collection("users").doc(user.uid);
      final userDoc = await userRef.get();

      if (userDoc.exists && userDoc.data()?["hasPet"] == false) {
        await userRef.update({"hasPet": true});
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void resetPetData(){
    petNameController.clear();
    petTypeController.clear();
    petAgeController.clear();
    petBreadController.clear();
    petGenderNotifier.value = Gender.male;
    petTypeNotifier.value = HavePet.yes;
    profileImageNotifier.value = null;
    petMainImageNotifier.value = null;
    petOtherImage1Notifier.value = null;
    petOtherImage2Notifier.value = null;
    petOtherImage3Notifier.value = null;
    petOtherImage4Notifier.value = null;
    petDocumentImageNotifier.value = null;


    addMorePet = false;
  }
}
