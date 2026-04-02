part of 'pet_cubit.dart';

abstract class PetState {}

final class PetInitial extends PetState {}

class PetLoadingState extends PetState {}

class PetSuccessState extends PetState {}

class PetErrorState extends PetState {
  final String error;

  PetErrorState(this.error);
}

class PetRefreshState extends PetState {}

class PetUpdateState extends PetState {}
