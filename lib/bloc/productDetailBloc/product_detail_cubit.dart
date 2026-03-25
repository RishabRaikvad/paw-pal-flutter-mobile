import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/model/cart_model.dart';
import 'package:paw_pal_mobile/model/product_model.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';

import '../../services/firestore_service.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductModel? productModel;
  FirebaseService service;
  final fireStore = FireStoreService().fireStore;

  ProductDetailCubit(this.service) : super(ProductDetailInitial());

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

  void addToCart(BuildContext context) async {
    emit(AddToCartLoadingState());
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null || productModel == null) return;
      String cartId = fireStore.collection("cart").doc().id;
      CartModel model = CartModel(
        cartId: cartId,
        productId: productModel?.id ?? "",
        userId: user.uid,
        productName: productModel?.name ?? "",
        productPrice: getTotalProductPrice(),
        unitPrice: getProductPrice(),
        productQuantity: productQuantity,
        productMainImage: productModel?.mainProductImage ?? "",
        variantType: productModel?.variantType ?? VariantType.none,
        variantTitle: productModel?.variants.isNotEmpty == true
            ? productModel?.variants[selectedVariant].title
            : "",
        createdAt: DateTime.now(),
      );
      await service.addToCart(model);
      CommonMethods().showSuccessToast("Product added to your cart");
      await Future.delayed(const Duration(milliseconds: 300));
      if (context.mounted) {
        context.pop();
      }
      emit(AddToCartSuccessState());
    } catch (e) {
      CommonMethods().showErrorToast(e.toString());
      emit(AddToCartErrorState());
    }
  }

  void resetData() {
    productModel = null;
    selectedVariant = 0;
    selectedImage = 0;
    productQuantity = 1;
    emit(ProductDetailInitial());
  }
}
