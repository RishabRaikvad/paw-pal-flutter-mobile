part of 'hospital_cubit.dart';

abstract class HospitalState {}

final class HospitalInitial extends HospitalState {}

final class HospitalError extends HospitalState {
  final String error;

  HospitalError(this.error);
}

final class HospitalSuccess extends HospitalState {}

final class HospitalLoading extends HospitalState {}

final class HospitalRefresh extends HospitalState {}
