import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit() : super(OrderDetailInitial());
}
