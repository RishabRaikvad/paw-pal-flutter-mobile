import 'package:bloc/bloc.dart';
import 'package:paw_pal_mobile/model/cart_model.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  FirebaseService service;

  CartCubit(this.service) : super(CartInitial());

  Stream<List<CartModel>> getCartItems() {
    return service.getCartItems();
  }
}
