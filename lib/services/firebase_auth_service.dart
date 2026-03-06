import 'package:paw_pal_mobile/model/faq_model.dart';
import 'package:paw_pal_mobile/model/hospital_model.dart';

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
}
