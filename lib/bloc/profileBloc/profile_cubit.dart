import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/pet_fees_model.dart';
import 'package:paw_pal_mobile/model/user_model.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/services/api_service.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';
import '../../core/constant.dart';
import '../../model/city_model.dart';
import '../../model/pet_model.dart';
import '../../model/state_model.dart';
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
  TextEditingController petDescriptionController = TextEditingController();
  TextEditingController petPriceController = TextEditingController();

  bool addMorePet = false;
  String? petId;
  final ValueNotifier<StateModel?> selectedStateNotifier = ValueNotifier(null);
  final ValueNotifier<CityModel?> selectedCityNotifier = ValueNotifier(null);
  final ValueNotifier<bool> isCityLoading = ValueNotifier(false);
  final ValueNotifier<int?> selectedPetYearsNotifier = ValueNotifier<int?>(
    null,
  );
  final ValueNotifier<int?> selectedPetMonthsNotifier = ValueNotifier<int?>(
    null,
  );

  void generatePetId() {
    petId = fireStore.collection("pets").doc().id;
  }

  ApiService service = ApiService();

  final List<StateModel> states = [];
  final List<CityModel> cities = [];

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
        name: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phone: user.phoneNumber ?? "",
        email: emailController.text.trim(),
        gender: getGenderText(genderNotifier.value),
        isProfileCompleted: true,
        address: addressController.text.trim(),
        state: stateController.text.trim(),
        city: cityController.text.trim(),
        pinCode: pinCodeController.text.trim(),
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
      final pet = PetModel(
        id: petId ?? "",
        ownerId: user.uid,
        name: petNameController.text.trim(),
        type: petTypeController.text.trim(),
        breed: petBreadController.text.trim(),
        age: petAge,
        gender: getGenderText(petGenderNotifier.value),
        petPrice: getAdoptionPrice,
        petDescription: petDescriptionController.text.trim(),
        mainImageUrl: petMainImage,
        otherImageUrls: otherImageUrls,
        vaccinationCertificateUrl: petDocumentImage,
        createdAt: DateTime.now(),
        isAdopted: false,
        isAvailable: true
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

  Future<bool> createPetCreateFess(String status, String paymentId) async {
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return false;
      final fessId = fireStore.collection("pet_creation_fees").doc().id;
      final petCreation = PetCreationFeeModel(
        id: fessId,
        ownerId: user.uid,
        petId: petId ?? "",
        amount: 250,
        currency: 'INR',
        status: status,
        razorpayPaymentId: paymentId,
        createdAt: DateTime.now(),
      );
      await authService.petCreationFess(petCreation);
      return true;
    } catch (e) {
      debugPrint("Errror : ${e.toString()}");
      return false;
    }
  }

  Future<void> fetchStates() async {
    try {
      final result = await service.fetchStates();
      states
        ..clear()
        ..addAll(result);
      emit(SuccessStateWiseCityState());
    } catch (e) {
      debugPrint("Error fetching states: ${e.toString()}");
      emit(ErrorStateWiseCityState());
    }
  }

  Future<void> fetchCities(String stateCode) async {
    isCityLoading.value = true;
    try {
      final result = await service.fetchCities(stateCode);
      cities
        ..clear()
        ..addAll(result);

      selectedCityNotifier.value = null;
      cityController.clear();

      emit(SuccessStateWiseCityState());
    } catch (e) {
      debugPrint("Error fetching cities: ${e.toString()}");
      emit(ErrorStateWiseCityState());
    } finally {
      isCityLoading.value = false;
    }
  }

  // ProfileCubit changes
  void selectState(StateModel val) {
    selectedStateNotifier.value = val;
    stateController.text = val.name;
    selectedCityNotifier.value = null;
    cityController.clear();
    fetchCities(val.iso2);
  }

  void selectCity(CityModel val) {
    selectedCityNotifier.value = val;
    cityController.text = val.name;
  }

  void resetPetData() {
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
    selectedPetYearsNotifier.value = null;
    selectedPetMonthsNotifier.value = null;
    addMorePet = false;
  }

  void resetAddressData() {
    addressController.clear();
    cityController.clear();
    stateController.clear();
    pinCodeController.clear();
    selectedStateNotifier.value = null;
    selectedCityNotifier.value = null;
    states.clear();
    cities.clear();

    emit(ProfileInitial());
  }

  void handlePetMonthChange(int month) {
    final currentYear = selectedPetYearsNotifier.value ?? 0;

    if (month >= 12) {
      selectedPetYearsNotifier.value = currentYear + (month ~/ 12);
      selectedPetMonthsNotifier.value = month % 12;
    } else {
      selectedPetMonthsNotifier.value = month;
    }
  }

  String getGenderText(Gender? gender) {
    if (gender == null) return "";
    return gender == Gender.male ? AppStrings.male : AppStrings.female;
  }


  String get petAge =>CommonMethods.formatPetAge(
      years: selectedPetYearsNotifier.value ?? 0,
      months: selectedPetMonthsNotifier.value ?? 0,
    );

  int get getAdoptionPrice => int.tryParse(petPriceController.text.trim()) ?? 0;

}
