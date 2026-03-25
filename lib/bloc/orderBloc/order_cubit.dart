import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/cart_model.dart';
import 'package:paw_pal_mobile/model/order_model.dart';
import 'package:paw_pal_mobile/progress_loader_screen.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';
import 'package:paw_pal_mobile/services/firestore_service.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  List<OrderModel> lstOrder = [];
  List<OrderModel> filterOrder = [];
  FirebaseService service;
  OrderStatus? selectedFilter;
  final fireStore = FireStoreService().fireStore;

  OrderCubit(this.service) : super(OrderInitial());

  Future<void> getOrders() async {
    emit(lstOrder.isEmpty ? OrderLoadingState() : OrderRefreshState());
    try {
      lstOrder = await service.getOrders();
     _applyFilter();
      emit(OrderSuccessState());
    } catch (e) {
      emit(OrderErrorState(e.toString()));
    }
  }

  void _applyFilter() {
    if (selectedFilter == null) {
      filterOrder = lstOrder;
    } else {
      filterOrder = lstOrder
          .where((order) => order.orderStatus == selectedFilter)
          .toList();
    }
  }

  void onFilterChange(OrderStatus? status) {
    selectedFilter = status;
   _applyFilter();
    emit(OrderSuccessState());
  }

  String getOrderStatusWiseIcon(OrderStatus status) {
    if (status == OrderStatus.delivered) {
      return AppImages.icOrderDelivered;
    } else if (status == OrderStatus.cancel) {
      return AppImages.icOrderCancel;
    }
    return AppImages.icOrderPending;
  }

  Future<void> cancelOrder(BuildContext context, String orderId) async {
    LoadingDialog.show(context);
    try {
      await service.cancelOrder(orderId);
      await getOrders();
      CommonMethods().showSuccessToast(
        "Your order has been cancelled successfully.",
      );
    } catch (e) {
      debugPrint("Errrorwnedkv : ${e.toString()}");
      CommonMethods().showErrorToast(e.toString());
    } finally {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    }
  }

  Future<void> reorderItem({
    required BuildContext context,
    required List<CartModel> cartItems,
  }) async {
    LoadingDialog.show(context);
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return;
      for (var items in cartItems) {
        final cartId = fireStore.collection("cart").doc().id;
        CartModel model = CartModel(
          cartId: cartId,
          productId: items.productId,
          userId: user.uid,
          productName: items.productName,
          productPrice: items.productPrice,
          unitPrice: items.unitPrice,
          productQuantity: items.productQuantity,
          productMainImage: items.productMainImage,
          variantType: items.variantType,
          createdAt: DateTime.now(),
        );
        await service.addToCart(model);
      }
      CommonMethods().showSuccessToast("Product added to your cart");
      if (!context.mounted) return;
      context.pop();
    } catch (e) {
      CommonMethods().showErrorToast(e.toString());
    } finally {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    }
  }

  void resetData(){
    selectedFilter = null;
    lstOrder = [];
    filterOrder = [];
    emit(OrderInitial());
  }
}
