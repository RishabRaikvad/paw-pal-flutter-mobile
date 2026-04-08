part of 'adoption_cubit.dart';

abstract class AdoptionState {}

final class AdoptionInitial extends AdoptionState {}

final class AdoptionUpdate extends AdoptionState {}

final class AdoptionLoadingState extends AdoptionState {}

final class AdoptionSuccessState extends AdoptionState {}

final class AdoptionError extends AdoptionState {
  String error;

  AdoptionError(this.error);
}
