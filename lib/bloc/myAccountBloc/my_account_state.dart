part of 'my_account_cubit.dart';

sealed class MyAccountState extends Equatable {
  const MyAccountState();
}

final class MyAccountInitial extends MyAccountState {
  @override
  List<Object> get props => [];
}
