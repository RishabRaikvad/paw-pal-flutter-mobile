import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String lastName;
  final String phone;
  final String email;
  final String gender;
  final bool isProfileCompleted;
  final String address;
  final String state;
  final String city;
  final String pinCode;
  final bool hasPet;
  final PetModel? pet;
  final DateTime createdAt;
  final String profileImageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.gender,
    required this.isProfileCompleted,
    required this.address,
    required this.state,
    required this.city,
    required this.pinCode,
    required this.hasPet,
    this.pet,
    required this.createdAt,
    required this.profileImageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      lastName: map['lastName'],
      phone: map['phone'],
      email: map['email'],
      gender: map['gender'],
      isProfileCompleted: map['isProfileCompleted'],
      address: map['address'],
      state: map['state'],
      city: map['city'],
      pinCode: map['pinCode'],
      hasPet: map['hasPet'] ?? false,
      pet: map['pet'] != null ? PetModel.fromMap(map['pet']) : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      profileImageUrl: map['profileImageUrl'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'lastName':lastName,
      'phone': phone,
      'email': email,
      'gender': gender,
      'isProfileCompleted': isProfileCompleted,
      'address': address,
      'state': state,
      'city': city,
      'pinCode': pinCode,
      'hasPet': hasPet,
      'pet': pet?.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'profileImageUrl': profileImageUrl,
    };
  }
}

class PetModel {
  final String name;
  final String type;
  final String breed;
  final int age;
  final String gender;
  final double adoptionPrice;
  final String mainImageUrl;
  final List<String> otherImageUrls;
  final String vaccinationCertificateUrl;
  final String adoptionCertificateUrl;

  PetModel({
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.gender,
    required this.adoptionPrice,
    required this.mainImageUrl,
    required this.otherImageUrls,
    required this.vaccinationCertificateUrl,
    required this.adoptionCertificateUrl,
  });

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      name: map['name'],
      type: map['type'],
      breed: map['breed'],
      age: map['age'],
      gender: map['gender'],
      adoptionPrice: (map['adoptionPrice'] as num).toDouble(),
      mainImageUrl: map['mainImageUrl'] ?? "",
      otherImageUrls: List<String>.from(map['otherImageUrls'] ?? []),
      vaccinationCertificateUrl: map['vaccinationCertificateUrl'] ?? "",
      adoptionCertificateUrl: map['adoptionCertificateUrl'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'breed': breed,
      'age': age,
      'gender': gender,
      'adoptionPrice': adoptionPrice,
      'mainImageUrl': mainImageUrl,
      'otherImageUrls': otherImageUrls,
      'vaccinationCertificateUrl': vaccinationCertificateUrl,
      'adoptionCertificateUrl': adoptionCertificateUrl,
    };
  }
}
