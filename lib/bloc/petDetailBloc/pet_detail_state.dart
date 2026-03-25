part of 'pet_detail_cubit.dart';

@immutable
sealed class PetDetailState {}

final class PetDetailInitial extends PetDetailState {}

final class PetDetailSuccess extends PetDetailState {}
