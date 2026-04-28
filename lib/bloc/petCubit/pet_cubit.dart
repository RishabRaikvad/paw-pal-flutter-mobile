import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/pet_with_owner.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';
import 'package:paw_pal_mobile/services/firestore_service.dart';

import '../../model/pet_category_model.dart';
import '../../model/pet_model.dart';

part 'pet_state.dart';

class PetCubit extends Cubit<PetState> {
  PetCubit() : super(PetInitial());
  final fireStore = FireStoreService().fireStore;
  String searchQuery = "";
  List<PetWithOwner> petList = [];
  List<PetCategoryModel> lstPetCategory = [];
  List<String> tempSelectedPrices = [];
  List<String> tempSelectedAges = [];
  List<String> tempSelectedGenders = [];
  PetCategoryModel? filterCategory;
  int? filterCategoryIndex;
  bool isAllFilterSelected = true;
  final List<String> priceRanges = [
    "Below ₹2.5K",
    "₹2.5K - ₹3.5K",
    "₹3.5K - ₹4.5K",
    "₹4.5K - ₹6K",
    "₹6K - ₹10K",
    "Above ₹10K",
  ];
  List<String> selectedPrices = [];

  final List<String> ages = [
    "Below 1 Year",
    "1 - 2 Years",
    "2 - 3.5 Years",
    "3.5 - 5 Years",
    "5 - 10 Years",
    "10+ Years",
  ];
  List<String> selectedAges = [];

  final List<String> genders = ["Male", "Female"];
  List<String> selectedGenders = [];

  void searchPets(String query) {
    searchQuery = query.toLowerCase();
    emit(PetUpdateState());
  }

  Future<void> loadPets() async {
    petList.isEmpty ? emit(PetLoadingState()) : emit(PetRefreshState());
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return;
      await getPetCategory();
      final petData = await fireStore
          .collection('pets')
          .where('isAvailable', isEqualTo: true)
          .where('ownerId', isNotEqualTo: user.uid)
          .orderBy('ownerId')
          .get();

      final pets = petData.docs.map((e) => PetModel.fromDoc(e)).toList();

      petList = await Future.wait(
        pets.map((pet) async {
          final ownerDoc = await fireStore
              .collection('users')
              .doc(pet.ownerId)
              .get();

          final ownerData = ownerDoc.data() ?? {};

          return PetWithOwner(
            pet: pet,
            ownerName: ownerData['name'] ?? '',
            ownerPhone: ownerData['phone'] ?? '',
            ownerAddress: ownerData['address'] ?? '',
            ownerCity: ownerData['city'] ?? '',
            ownerState: ownerData['state'] ?? '',
            ownerImage: ownerData['profileImageUrl'] ?? "",
            ownerEmail: ownerData['email'] ?? "",
            ownerLastName: ownerData['lastName'] ?? "",
            pinCode: ownerData['pinCode'] ?? "",
          );
        }),

      );
      emit(PetSuccessState());
    } catch (e) {
      emit(PetErrorState(e.toString()));
    }
  }

  void togglePrice(String value) {
    if (tempSelectedPrices.contains(value)) {
      tempSelectedPrices.remove(value);
    } else {
      tempSelectedPrices.add(value);
    }
    emit(PetUpdateState());
  }

  void toggleAge(String value) {
    if (tempSelectedAges.contains(value)) {
      tempSelectedAges.remove(value);
    } else {
      tempSelectedAges.add(value);
    }
    emit(PetUpdateState());
  }

  void toggleGender(String value) {
    if (tempSelectedGenders.contains(value)) {
      tempSelectedGenders.remove(value);
    } else {
      tempSelectedGenders.add(value);
    }
    emit(PetUpdateState());
  }

  List<PetWithOwner> get filteredPets {
    List<PetWithOwner> temp = petList;
    if (searchQuery.isNotEmpty) {
      temp = temp.where((pet) {
        final name = pet.pet.name.toLowerCase();
        final breed = pet.pet.breed.toLowerCase();
        final city = pet.ownerCity.toLowerCase();

        return name.contains(searchQuery) ||
            breed.contains(searchQuery) ||
            city.contains(searchQuery);
      }).toList();
    }

    if (!isAllFilterSelected && filterCategory != null) {
      temp = temp.where((pet) {
        return pet.pet.type == filterCategory!.categoryName;
      }).toList();
    }

    if (selectedPrices.isNotEmpty) {
      temp = temp.where((pet) {
        num price = pet.pet.petPrice;

        return selectedPrices.any((range) {
          if (range == "Below ₹2.5K") return price < 2500;
          if (range == "₹2.5K - ₹3.5K") return price >= 2500 && price <= 3500;
          if (range == "₹3.5K - ₹4.5K") return price >= 3500 && price <= 4500;
          if (range == "₹4.5K - ₹6K") return price >= 4500 && price <= 6000;
          if (range == "₹6K - ₹10K") return price >= 6000 && price <= 10000;
          if (range == "Above ₹10K") return price > 10000;
          return false;
        });
      }).toList();
    }

    if (selectedAges.isNotEmpty) {
      temp = temp.where((pet) {
        double age = _parseAge(pet.pet.age);

        return selectedAges.any((range) {
          if (range == "Below 1 Year") return age < 1;
          if (range == "1 - 2 Years") return age >= 1 && age <= 2;
          if (range == "2 - 3.5 Years") return age >= 2 && age <= 3.5;
          if (range == "3.5 - 5 Years") return age >= 3.5 && age <= 5;
          if (range == "5 - 10 Years") return age >= 5 && age <= 10;
          if (range == "10+ Years") return age > 10;
          return false;
        });
      }).toList();
    }

    if (selectedGenders.isNotEmpty) {
      temp = temp.where((pet) {
        return selectedGenders.contains(pet.pet.gender);
      }).toList();
    }

    return temp;
  }

  double _parseAge(String ageString) {
    final regex = RegExp(r'[\d.]+'); // extract numbers like 2, 3.5
    final match = regex.firstMatch(ageString);

    if (match != null) {
      return double.tryParse(match.group(0)!) ?? 0;
    }
    return 0;
  }

  void applyFilters(BuildContext context) {
    if (tempSelectedGenders.isEmpty &&
        tempSelectedAges.isEmpty &&
        tempSelectedPrices.isEmpty) {
      CommonMethods().showErrorToast(
        "Please Select At Least One Filter For See Your Furry Friend",
      );
      return;
    } else {
      selectedPrices = List.from(tempSelectedPrices);
      selectedAges = List.from(tempSelectedAges);
      selectedGenders = List.from(tempSelectedGenders);
      emit(PetUpdateState());
      context.pop();
    }
  }

  Future<void> getPetCategory() async {
    try {
      lstPetCategory = await FirebaseService().getPetCategory();

    } catch (e) {
      debugPrint("Error in pet category : $e");
    }
  }

  void selectAllFilter() {
    filterCategory = null;
    filterCategoryIndex = 0;
    isAllFilterSelected = true;
    emit(PetUpdateState());
  }

  void selectFilterCategory(PetCategoryModel category, int index) {
    filterCategory = category;
    filterCategoryIndex = index;
    isAllFilterSelected = false;
    emit(PetUpdateState());
  }

  void resetFilters() {
    selectedPrices.clear();
    selectedAges.clear();
    selectedGenders.clear();
    tempSelectedPrices.clear();
    tempSelectedAges.clear();
    tempSelectedGenders.clear();
    filterCategory = null;
    filterCategoryIndex = null;
    isAllFilterSelected = true;
    emit(PetInitial());
  }
}
