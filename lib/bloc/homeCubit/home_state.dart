part of 'home_cubit.dart';

abstract class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {}

final class HomeSuccessState extends HomeState {}

final class HomeErrorState extends HomeState {
  final String error;

  const HomeErrorState(this.error);
}

final class HomeLoadState extends HomeState {}

final class HomeRefreshState extends HomeState {}
