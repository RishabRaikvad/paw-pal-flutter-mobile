
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/model/product_model.dart';
import 'package:paw_pal_mobile/routes/routes.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductModel? productModel;

  ProductDetailCubit() : super(ProductDetailInitial());

  int selectedImage = 0;
  int selectedVariant = 0;
  int productQuantity = 1;

  void navigateToProductDetailScreen({
    required BuildContext context,
    required ProductModel model,
  }) {
    productModel = model;
    context.pushNamed(Routes.productDetailScreen);
    emit(ProductDetailSuccessState());
  }

  void changeImage(int index) {
    selectedImage = index;
    emit(ProductDetailSuccessState());
  }

  void changeVariant(int index) {
    selectedVariant = index;
    emit(ProductDetailSuccessState());
  }

  double getProductPrice() {
    if (productModel?.variants.isNotEmpty == true) {
      return productModel!.variants[selectedVariant].price;
    }
    return productModel?.basePrice ?? 0.0;
  }

  void increaseProductQuantity() {
    productQuantity++;
    emit(ProductDetailSuccessState());
  }

  void decreaseProductQuantity() {
    if (productQuantity > 1) {
      productQuantity--;
    }
    emit(ProductDetailSuccessState());
  }

  double getTotalProductPrice() {
    return getProductPrice() * productQuantity;
  }

  void resetData() {
    productModel = null;
    selectedVariant = 0;
    selectedImage = 0;
    productQuantity = 1;
    emit(ProductDetailInitial());
  }
}
