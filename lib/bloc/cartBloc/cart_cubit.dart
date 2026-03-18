import 'package:bloc/bloc.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/BillDetailModel.dart';
import 'package:paw_pal_mobile/model/cart_model.dart';

import '../../services/firebase_auth_service.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  FirebaseService service;

  CartCubit(this.service) : super(CartInitial());

  Stream<List<CartModel>> getCartItems() {
    try {
      final stream = service.getCartItems();

      return stream
          .map((event) {
            return event;
          })
          .handleError((error) {
            CommonMethods().showErrorToast("Error in stream: $error");
          });
    } catch (e) {
      CommonMethods().showErrorToast("Exception caught: $e");
      return const Stream.empty();
    }
  }

  void increaseQuantity(CartModel item) async {
    final previousQty = item.productQuantity;
    try {
      final newQty = previousQty + 1;
      final productPrice = item.unitPrice * newQty;
      await service.updateQuantity(item.cartId, newQty, productPrice);
    } catch (e) {
      item.productQuantity = previousQty;
      CommonMethods().showErrorToast("Increase failed: $e");
    }
  }

  void decreaseQuantity(CartModel item) async {
    final previousQty = item.productQuantity;
    try {
      final newQty = previousQty - 1;
      final productPrice = item.unitPrice * newQty;
      if (newQty > 0) {
        await service.updateQuantity(item.cartId, newQty, productPrice);
      } else {
        await removeItm(item);
      }
    } catch (e) {
      item.productQuantity = previousQty;
      CommonMethods().showErrorToast("decrease failed: $e");
    }
  }

  Future<void> removeItm(CartModel model) async {
    try {
      await service.removeItem(model.cartId);
    } catch (e) {
      CommonMethods().showErrorToast("$e");
    }
  }

  BillDetails calculateBil(List<CartModel> cartItems) {
    double itemTotal = 0;
    for (var item in cartItems) {
      itemTotal += item.productPrice;
    }
    double deliveryCharge = 40;
    double platformFee = 25;
    double subTotal = itemTotal + deliveryCharge;
    double gst = subTotal * 0.05;
    double total = subTotal + platformFee + gst;
    return BillDetails(
      itemTotal: itemTotal,
      deliveryCharge: deliveryCharge,
      platformFee: platformFee,
      gst: gst,
      subTotal: subTotal,
      total: total,
    );
  }
}
