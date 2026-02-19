part of 'manage_paw_cubit.dart';

sealed class ManagePawState extends Equatable {
  const ManagePawState();
}

final class ManagePawInitial extends ManagePawState {
  @override
  List<Object> get props => [];
}

final class ManagePawSuccessState extends ManagePawState {
  @override
  List<Object> get props => [];
}

final class ManagePawErrorState extends ManagePawState {
  final String error;

  const ManagePawErrorState(this.error);

  @override
  List<Object> get props => [error];
}

final class ManagePawLoadState extends ManagePawState {
  @override
  List<Object> get props => [];
}

final class ManagePawRefreshState extends ManagePawState {
  @override
  List<Object> get props => [];
}
