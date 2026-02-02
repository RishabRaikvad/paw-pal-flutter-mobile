import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  FireStoreService._internal();

  static final FireStoreService _instance = FireStoreService._internal();

  factory FireStoreService() => _instance;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
}
