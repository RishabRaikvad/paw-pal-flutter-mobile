import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';
import 'package:paw_pal_mobile/bloc/myAccountBloc/my_account_cubit.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/adoption_request_model.dart';
import 'package:paw_pal_mobile/model/pet_with_owner.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';

import '../../services/firestore_service.dart';

part 'adoption_state.dart';

class AdoptionCubit extends Cubit<AdoptionState> {
  PetWithOwner? petWithOwner;
  FirebaseService service;

  AdoptionCubit(this.service) : super(AdoptionInitial());
  final fireStore = FireStoreService().fireStore;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController adoptionMsgController = TextEditingController();
  bool hasPetExperience = false;
  bool isAgree = false;

  void navigateAdoptionFormScreen(BuildContext context, PetWithOwner model) {
    petWithOwner = model;
    context.pushNamed(Routes.petAdoptionScreen);
  }

  void selectPetExperience(bool value) {
    hasPetExperience = value;
    emit(AdoptionUpdate());
  }

  void onAgreeChange(bool value) {
    isAgree = value;
    emit(AdoptionUpdate());
  }

  Future<bool> sendAdoptionRequest(BuildContext context) async {
    emit(AdoptionLoadingState());
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return false;
      String requestId = fireStore.collection("pet_adoption_request").doc().id;
      AdoptionRequestModel model = AdoptionRequestModel(
        requestId: requestId,
        petId: petWithOwner?.pet.id ?? "",
        petName: petWithOwner?.pet.name ?? "",
        petOwnerId: petWithOwner?.pet.ownerId ?? "",
        petBuyerId: user.uid,
        petOwnerProfileImage: petWithOwner?.ownerImage ?? "",
        petBuyerProfileImage: context.read<MyAccountCubit>().getProfileImage(),
        fullName: firstNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        ownerAddress: getOwnerAddress(petWithOwner!),
        message: adoptionMsgController.text.trim(),
        experience: hasPetExperience,
        status: AdoptionStatus.pending,
        createdAt: DateTime.now(),
        ownerEmail: petWithOwner?.ownerEmail ?? "",
        ownerName: petWithOwner?.ownerName ?? "",
        ownerPhone: petWithOwner?.ownerPhone ?? "",
        petAge: petWithOwner?.pet.age ?? "",
        petBreed: petWithOwner?.pet.breed ?? "",
        petGender: petWithOwner?.pet.gender ?? "",
        petImage: petWithOwner?.pet.mainImageUrl ?? "",
        petPrice: petWithOwner?.pet.petPrice ?? 0

      );
      await service.createPetAdoptionRequest(model);
      emit(AdoptionSuccessState());
      return true;
    } catch (e) {
      return false;
    }
  }

  String getOwnerAddress(PetWithOwner model) {
    return "${model.ownerAddress} ${model.ownerCity} ${model.ownerState},${model.pinCode}";
  }


}
