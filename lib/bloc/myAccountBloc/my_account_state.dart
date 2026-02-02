part of 'my_account_cubit.dart';

sealed class MyAccountState extends Equatable {
  const MyAccountState();
}

final class MyAccountInitial extends MyAccountState {
  @override
  List<Object> get props => [];
}

final class SuccessMyAccountState extends MyAccountState {
  @override
  List<Object> get props => [];
}

final class LoadMyAccountState extends MyAccountState {
  @override
  List<Object> get props => [];
}

final class ErrorMyAccountState extends MyAccountState {
  final String error;

  const ErrorMyAccountState(this.error);

  @override
  List<Object> get props => [error];
}
