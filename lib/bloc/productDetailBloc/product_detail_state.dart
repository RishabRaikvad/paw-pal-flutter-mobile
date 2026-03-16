part of 'product_detail_cubit.dart';

abstract class ProductDetailState {}

final class ProductDetailInitial extends ProductDetailState {}

final class ProductDetailSuccessState extends ProductDetailState {}
final class AddToCartSuccessState extends ProductDetailState {}
final class AddToCartErrorState extends ProductDetailState {}
final class AddToCartLoadingState extends ProductDetailState {}


