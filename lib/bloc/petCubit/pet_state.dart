part of 'pet_cubit.dart';

sealed class PetState extends Equatable {
  const PetState();
}

final class PetInitial extends PetState {
  @override
  List<Object> get props => [];
}

class PetLoadingState extends PetState {
  @override
  List<Object?> get props => [];
}

class PetSuccessState extends PetState {
  @override
  List<Object?> get props => [];
}

class PetErrorState extends PetState {
  final String error;

  const PetErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
