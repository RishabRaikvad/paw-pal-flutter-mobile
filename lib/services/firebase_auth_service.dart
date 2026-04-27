import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/adoption_request_model.dart';
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
    await _fireStore
        .collection("orders")
        .doc(model.orderId)
        .set(model.toJson());
  }

  Future<void> clearUserCart(String userId) async {
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

  Future<void> manageFcmToken(String fcmToken) async {
    final user = CommonMethods.getCurrentUser();
    if (user == null) return;
    await _fireStore.collection("users").doc(user.uid).set({
      "fcmTokens": FieldValue.arrayUnion([fcmToken]),
    }, SetOptions(merge: true));
  }

  Future<List<OrderModel>> getOrders() async {
    final user = CommonMethods.getCurrentUser();
    if (user == null) return [];
    final snapshot = await _fireStore
        .collection("orders")
        .where("userId", isEqualTo: user.uid)
        .orderBy("createdAt", descending: true)
        .get();
    return snapshot.docs.map((e) => OrderModel.fromJson(e.data())).toList();
  }

  Future<void> cancelOrder(String orderId) async {
    await _fireStore.collection("orders").doc(orderId).update({
      "orderStatus": OrderStatus.cancel.name,
    });
  }

  Future<void> createPetAdoptionRequest(AdoptionRequestModel model) async {
    await _fireStore
        .collection("pet_adoption_request")
        .doc(model.requestId)
        .set(model.toJson());
  }

  Future<List<AdoptionRequestModel>> myAdoptionRequests() async {
    final user = CommonMethods.getCurrentUser();
    if (user == null) return [];
    final snapshot = await _fireStore.collection("pet_adoption_request").get();
    return snapshot.docs
        .map((e) => AdoptionRequestModel.fromJson(e.data()))
        .where(
          (item) => item.petOwnerId == user.uid || item.petBuyerId == user.uid,
        )
        .toList();
  }

  Future<void> updateRequestStatus(
    String requestId,
    AdoptionStatus status,
  ) async {
    try {
      await _fireStore.collection("pet_adoption_request").doc(requestId).update(
        {"status": status.name},
      );
    } catch (e) {
      print("Update Status Error: $e");
    }
  }

  Future<void> completeAdoptionProcess(AdoptionRequestModel model) async {
    // Step 1: Atomic transaction for critical updates
    await _fireStore.runTransaction((transaction) async {
      final requestRef = _fireStore
          .collection("pet_adoption_request")
          .doc(model.requestId);

      final petRef = _fireStore.collection("pets").doc(model.petId);

      final petSnap = await transaction.get(petRef);

      // Prevent duplicate adoption
      if (petSnap['isAdopted'] == true) {
        throw Exception("Pet has already been adopted.");
      }

      // Mark request as completed
      transaction.update(requestRef, {
        'status': AdoptionStatus.completed.name,
        'completedAt': FieldValue.serverTimestamp(),
      });

      // Transfer ownership
      transaction.update(petRef, {
        'ownerId': model.petBuyerId,
        'isAdopted': true,
        'isAvailable': false,
        'adoptedAt': FieldValue.serverTimestamp(),
      });
    });

    // Step 2: Reject all other pending requests for this pet
    final query = await _fireStore
        .collection("pet_adoption_request")
        .where('petId', isEqualTo: model.petId)
        .get();

    final batch = _fireStore.batch();

    for (var doc in query.docs) {
      if (doc.id != model.requestId &&
          doc['status'] != AdoptionStatus.rejected.name &&
          doc['status'] != AdoptionStatus.completed.name) {
        batch.update(doc.reference, {
          'status': AdoptionStatus.rejected.name,
          'rejectedAt': FieldValue.serverTimestamp(),
        });
      }
    }

    // Step 3: Commit batch with error handling
    try {
      await batch.commit();
    } catch (e) {
      debugPrint("Failed to reject other adoption requests: $e");

    }
  }}
