import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/model/order_model.dart';
import 'package:paw_pal_mobile/routes/routes.dart';

part 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderModel? model;

  OrderDetailCubit() : super(OrderDetailInitial());

  void navigateToOrderDetailScreen(BuildContext context, OrderModel model) {
    this.model = model;
    context.pushNamed(Routes.orderDetailScreen);
    emit(OrderDetailSuccessState());
  }

  String getOrderStatusWiseIcon(OrderStatus status) {
    if (status == OrderStatus.delivered) {
      return AppImages.icOrderDetailDelivered;
    } else if (status == OrderStatus.cancel) {
      return AppImages.icOrderDetailCancel;
    }
    return AppImages.icOrderDetailPending;
  }

  Color getOrderStatusColor(OrderStatus status) {
    if (status == OrderStatus.delivered) {
      return AppColors.orderDeliveredColor;
    } else if (status == OrderStatus.cancel) {
      return AppColors.orderCancelColor;
    }
    return AppColors.orderPendingColor;
  }


  Color getOrderDateColor(OrderStatus status) {
    if (status == OrderStatus.delivered) {
      return AppColors.greenColor;
    } else if (status == OrderStatus.cancel) {
      return AppColors.redColor;
    }
    return AppColors.primaryColor;
  }

  String getOrderAddressDetail(ShippingAddress address) {
    return "${address.address} ${address.city} ${address.state} ${address.pinCode}";
  }

  String getOrderUserDetail(ShippingAddress address) {
    return "${address.name} ${AppStrings.dot} +91${address.phone}";
  }
}
