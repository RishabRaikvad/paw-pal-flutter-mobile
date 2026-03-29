import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';
import 'package:paw_pal_mobile/model/pet_with_owner.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';

part 'adoption_state.dart';

class AdoptionCubit extends Cubit<AdoptionState> {
  PetWithOwner? model;
  FirebaseService service;

  AdoptionCubit(this.service) : super(AdoptionInitial());

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController adoptionMsgController = TextEditingController();
  bool hasPetExperience = false;
  bool isAgree = false;

  void navigateAdoptionFormScreen(BuildContext context, PetWithOwner model) {
    this.model = model;
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
}
