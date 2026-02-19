import 'package:cloud_firestore/cloud_firestore.dart';

class PetModel {
  final String id;
  final String ownerId;
  final String name;
  final String type;
  final String breed;
  final String age;
  final String gender;
  final String petDescription;
  final int petPrice;
  final String? mainImageUrl;
  final List<String> otherImageUrls;
  final String? vaccinationCertificateUrl;
  final bool isAdopted;
  final bool isAvailable;
  final DateTime createdAt;

  PetModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.gender,
    required this.petDescription,
    required this.petPrice,
    required this.mainImageUrl,
    required this.otherImageUrls,
    required this.vaccinationCertificateUrl,
    required this.isAdopted,
    required this.isAvailable,
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
      petDescription: map['petDescription'],
      petPrice: map['petPrice'],
      mainImageUrl: map['mainImageUrl'],
      otherImageUrls: List<String>.from(map['otherImageUrls'] ?? []),
      vaccinationCertificateUrl: map['vaccinationCertificateUrl'],
      isAdopted: map['isAdopted'] ?? false,
      isAvailable: map['isAvailable'] ?? false,
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
      'petDescription': petDescription,
      'petPrice': petPrice,
      'mainImageUrl': mainImageUrl,
      'otherImageUrls': otherImageUrls,
      'vaccinationCertificateUrl': vaccinationCertificateUrl,
      'isAdopted': isAdopted,
      'isAvailable': isAvailable,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
