import 'package:cloud_firestore/cloud_firestore.dart';

class PetModel {
  final String id;
  final String ownerId;
  final String name;
  final String type;
  final String breed;
  final int age;
  final String gender;
  final String? mainImageUrl;
  final List<String> otherImageUrls;
  final String? vaccinationCertificateUrl;
  final bool isAdopted;
  final DateTime createdAt;

  PetModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.gender,
    required this.mainImageUrl,
    required this.otherImageUrls,
    required this.vaccinationCertificateUrl,
    required this.isAdopted,
    required this.createdAt,
  });

  factory PetModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return PetModel(
      id: doc.id,
      ownerId: map['ownerId'],
      name: map['name'],
      type: map['type'],
      breed: map['breed'],
      age: map['age'],
      gender: map['gender'],
      mainImageUrl: map['mainImageUrl'],
      otherImageUrls: List<String>.from(map['otherImageUrls'] ?? []),
      vaccinationCertificateUrl: map['vaccinationCertificateUrl'],
      isAdopted: map['isAdopted'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'type': type,
      'breed': breed,
      'age': age,
      'gender': gender,
      'mainImageUrl': mainImageUrl,
      'otherImageUrls': otherImageUrls,
      'vaccinationCertificateUrl': vaccinationCertificateUrl,
      'isAdopted': isAdopted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
