part of 'order_cubit.dart';

abstract class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderLoadingState extends OrderState {}

final class OrderSuccessState extends OrderState {}

final class OrderErrorState extends OrderState {
  final String error;

  OrderErrorState(this.error);
}

final class OrderRefreshState extends OrderState {}
