import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/pet_fees_model.dart';
import '../model/pet_model.dart';
import '../model/user_model.dart';

class FirebaseAuthService {

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

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
    await _fireStore.collection("pet_creation_fees").doc(petCreation.id).set(petCreation.toMap());
  }


}