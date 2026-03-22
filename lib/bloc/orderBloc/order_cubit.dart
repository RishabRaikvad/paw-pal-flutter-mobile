import 'package:bloc/bloc.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/model/order_model.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  List<OrderModel> lstOrder = [];
  List<OrderModel> filterOrder = [];
  FirebaseService service;
  OrderStatus? selectedFilter;

  OrderCubit(this.service) : super(OrderInitial());

  Future<void> getOrders() async {
    emit(lstOrder.isEmpty ? OrderLoadingState() : OrderRefreshState());
    try {
      lstOrder = await service.getOrders();
      filterOrder = lstOrder;
      emit(OrderSuccessState());
    } catch (e) {
      emit(OrderErrorState(e.toString()));
    }
  }

  void onFilterChange(OrderStatus? status) {
    selectedFilter = status;
    if (status == null) {
      filterOrder = lstOrder;
    } else {
      filterOrder = lstOrder
          .where((order) => order.orderStatus == status)
          .toList();
    }
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
}
