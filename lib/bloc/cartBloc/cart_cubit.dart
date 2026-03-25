import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_mobile/bloc/myAccountBloc/my_account_cubit.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/BillDetailModel.dart';
import 'package:paw_pal_mobile/model/cart_model.dart';
import 'package:paw_pal_mobile/model/order_model.dart';
import 'package:paw_pal_mobile/services/firestore_service.dart';

import '../../services/firebase_auth_service.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  FirebaseService service;
  final fireStore = FireStoreService().fireStore;
  List<CartModel> currentCartItems = [];

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

  ShippingAddress shippingAddress(BuildContext context) {
    final cubit = context.read<MyAccountCubit>();
    return ShippingAddress(
      name: cubit.getFullName(),
      phone: cubit.getPhoneNumber,
      address: cubit.getAddress,
      city: cubit.getCity(),
      state: cubit.getState(),
      pinCode: cubit.userModel?.pinCode ?? "",
    );
  }

  Future<void> createOrder({
    required BuildContext context,
    required String status,
    required List<CartModel> cartItems,
    required String razorpayPaymentId,
  }) async {
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return;

      final orderId = fireStore.collection("orders").doc().id;
      OrderModel model = OrderModel(
        orderId: orderId,
        userId: user.uid,
        items: cartItems,
        billing: calculateBil(cartItems),
        paymentStatus: status,
        orderStatus: OrderStatus.pending,
        createdAt: DateTime.now(),
        shippingAddress: shippingAddress(context),
        razorpayPaymentId: razorpayPaymentId,
      );
      await service.createOrder(model);
    } catch (e) {
      CommonMethods().showErrorToast("$e");
    }
  }

  Future<void> clearCart() async {
    final user = CommonMethods.getCurrentUser();
    if (user == null) return;
    await service.clearUserCart(user.uid);
  }
}
