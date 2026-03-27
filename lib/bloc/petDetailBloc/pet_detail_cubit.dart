import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';
import 'package:paw_pal_mobile/model/pet_with_owner.dart';
import 'package:paw_pal_mobile/routes/routes.dart';

part 'pet_detail_state.dart';

class PetDetailCubit extends Cubit<PetDetailState> {
  PetWithOwner? model;

  PetDetailCubit() : super(PetDetailInitial());

  void navigateToPetDetailScreen(BuildContext context, PetWithOwner model) {
    this.model = model;
    context.pushNamed(Routes.petDetailScreen);
    emit(PetDetailSuccess());
  }
  int selectedImage = 0;

  void changeImage(int index) {
    selectedImage = index;
    emit(PetDetailSuccess());
  }
  // void navigateToAdoptionFormScreen(BuildContext context, PetWithOwner model) {
  //   this.model = model;
  //   context.pushNamed(Routes.petDetailScreen);
  //   emit(PetDetailSuccess());
  // }

  String getOwnerAddress(PetWithOwner model){
    return "${model.ownerAddress} ${model.ownerCity} ${model.ownerState},${model.pinCode}";
  }

  resetData(){
    selectedImage = 0;
    emit(PetDetailInitial());
  }

}
