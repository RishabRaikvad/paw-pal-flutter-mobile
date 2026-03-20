import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/cart_model.dart';
import 'package:paw_pal_mobile/model/faq_model.dart';
import 'package:paw_pal_mobile/model/hospital_model.dart';
import 'package:paw_pal_mobile/model/order_model.dart';

import '../model/pet_fees_model.dart';
import '../model/pet_model.dart';
import '../model/product_category_model.dart';
import '../model/product_model.dart';
import '../model/user_model.dart';
import 'firestore_service.dart';

class FirebaseService {
  final _fireStore = FireStoreService().fireStore;

  Future<bool> isProfileCompleted(String uid) async {
    final doc = await _fireStore.collection("users").doc(uid).get();
    if (!doc.exists) return false;
    return doc.data()?['isProfileCompleted'] ?? false;
  }

  Future<void> createUser(UserModel user) async {
    await _fireStore.collection("users").doc(user.uid).set(user.toMap());
  }

  Future<void> createPet(PetModel pet) async {
    await _fireStore.collection("pets").doc(pet.id).set(pet.toMap());
  }

  Future<void> petCreationFess(PetCreationFeeModel petCreation) async {
    await _fireStore
        .collection("pet_creation_fees")
        .doc(petCreation.id)
        .set(petCreation.toMap());
  }

  Future<List<ProductModel>> getProducts() async {
    final snapshot = await _fireStore.collection("products").get();
    return snapshot.docs.map((e) => ProductModel.fromJson(e.data())).toList();
  }

  Future<List<ProductCategoryModel>> getProductCategory() async {
    final snapshot = await _fireStore.collection("product_category").get();
    return snapshot.docs
        .map((e) => ProductCategoryModel.fromJson(e.data()))
        .toList();
  }

  Future<List<FaqModel>> getFaq() async {
    final snapshot = await _fireStore.collection("faq's").get();
    return snapshot.docs.map((e) => FaqModel.fromJson(e.data())).toList();
  }

  Future<List<HospitalModel>> getHospitals() async {
    final snapshot = await _fireStore
        .collection("hospitals")
        .where("isAvailable", isEqualTo: true)
        .get();
    return snapshot.docs.map((e) => HospitalModel.fromJson(e.data())).toList();
  }

  Future<void> addToCart(CartModel model) async {
    await _fireStore.collection("cart").doc(model.cartId).set(model.toJson());
  }

  Stream<List<CartModel>> getCartItems() {
    final user = CommonMethods.getCurrentUser();
    if (user == null) {
      return Stream.value([]);
    }
    return _fireStore
        .collection("cart")
        .where("userId", isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CartModel.fromJson(doc.data()))
              .toList();
        });
  }

  Future<void> updateQuantity(
    String cartId,
    int quantity,
    double productPrice,
  ) async {
    await _fireStore.collection('cart').doc(cartId).update({
      'productQuantity': quantity,
      'productPrice': productPrice,
    });
  }

  Future<void> removeItem(String cartId) async {
    await _fireStore.collection('cart').doc(cartId).delete();
  }

  Future<void> createOrder(OrderModel model) async {
    await _fireStore.collection("orders").doc(model.orderId).set(model.toJson());
  }

  Future<void> clearUserCart(String userId)async{
    final batch = _fireStore.batch();
    final snapshot = await _fireStore
        .collection("cart")
        .where("userId", isEqualTo: userId)
        .get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> manageFcmToken(String fcmToken)async{
    final user = CommonMethods.getCurrentUser();
    if (user == null) return;
    await _fireStore.collection("users").doc(user.uid).set({
      "fcmTokens": FieldValue.arrayUnion([fcmToken]),
    }, SetOptions(merge: true));
  }
}
