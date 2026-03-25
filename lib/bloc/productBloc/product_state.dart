part of 'product_cubit.dart';

abstract class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoadState extends ProductState {}

final class ProductSuccessState extends ProductState {}
final class ProductRefreshState extends ProductState {}

final class ProductErrorState extends ProductState {
  String error;

  ProductErrorState(this.error);
}

final class ProductUpdateState extends ProductState {}


