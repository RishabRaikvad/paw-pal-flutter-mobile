
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
  final DateTime createdAt;
  final String? profileImageUrl;

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

      'createdAt': Timestamp.fromDate(createdAt),
      'profileImageUrl': profileImageUrl,
    };
  }
}


