import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/pet_model.dart';
import 'package:paw_pal_mobile/services/firestore_service.dart';

import '../../model/pet_fees_model.dart';
import '../../services/firebase_auth_service.dart';

part 'manage_paw_state.dart';

class ManagePawCubit extends Cubit<ManagePawState> {
  ManagePawCubit() : super(ManagePawInitial());

  final fireStore = FireStoreService().fireStore;
  FirebaseService authService = FirebaseService();
  List<PetModel> lstMyPets = [];
  Map<String, ValueNotifier<bool>> adoptionStatus = {};

  Future<void> loadMyPets() async {
    lstMyPets.isEmpty
        ? emit(ManagePawLoadState())
        : emit(ManagePawRefreshState());
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return;

      final snapshot = await fireStore
          .collection("pets")
          .where('ownerId', isEqualTo: user.uid)
          .get();

      lstMyPets = snapshot.docs.map((doc) => PetModel.fromDoc(doc)).toList();

      for (var pet in lstMyPets) {
        final notifier = adoptionStatus.putIfAbsent(
          pet.id,
              () => ValueNotifier<bool>(pet.isAvailable),
        );

        notifier.value = pet.isAvailable;
      }

      emit(ManagePawSuccessState());
    } catch (e) {
      emit(ManagePawErrorState(e.toString()));
    }
  }

  Future<void> toggleAdoptionStatus(
      String petId,
      bool newValue,
      ) async {
    final notifier = adoptionStatus[petId];
    if (notifier == null) return;

    final old = notifier.value;
    notifier.value = newValue;

    try {
      await fireStore
          .collection("pets")
          .doc(petId)
          .update({"isAvailable": newValue});
    } catch (e) {
      notifier.value = old;
      emit(ManagePawErrorState(e.toString()));
    }
  }

  Future<bool> createPetCreateFess(String status, String paymentId,String petId) async {
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return false;
      final fessId = fireStore.collection("pet_creation_fees").doc().id;
      final petCreation = PetCreationFeeModel(
        id: fessId,
        ownerId: user.uid,
        petId: petId ,
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

}
