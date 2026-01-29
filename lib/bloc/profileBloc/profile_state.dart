part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

final class LoadStateWiseCityState extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class SuccessStateWiseCityState extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class ErrorStateWiseCityState extends ProfileState {
  @override
  List<Object?> get props => [];
}
