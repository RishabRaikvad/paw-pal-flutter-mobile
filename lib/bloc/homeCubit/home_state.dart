part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

final class HomeSuccessState extends HomeState {
  @override
  List<Object> get props => [];
}

final class HomeErrorState extends HomeState {
  final String error;

  const HomeErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

final class HomeLoadState extends HomeState {
  @override
  List<Object> get props => [];
}
