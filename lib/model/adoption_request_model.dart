import 'package:cloud_firestore/cloud_firestore.dart';

enum AdoptionStatus { pending, approved, rejected, completed }

class AdoptionRequestModel {
  final String requestId;

  final String petId;
  final String petName;

  final String petOwnerId;   // from pet.ownerId
  final String petBuyerId;   // current user

  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String message;
  final String experience;

  final AdoptionStatus status;

  final DateTime createdAt;

  AdoptionRequestModel({
    required this.requestId,
    required this.petId,
    required this.petName,
    required this.petOwnerId,
    required this.petBuyerId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.message,
    required this.experience,
    required this.status,
    required this.createdAt,
  });

  factory AdoptionRequestModel.fromJson(Map<String, dynamic> json) {
    return AdoptionRequestModel(
      requestId: json['requestId'] ?? '',
      petId: json['petId'] ?? '',
      petName: json['petName'] ?? '',
      petOwnerId: json['petOwnerId'] ?? '',
      petBuyerId: json['petBuyerId'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      message: json['message'] ?? '',
      experience: json['experience'] ?? '',
      status: AdoptionStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => AdoptionStatus.pending,
      ),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "requestId": requestId,
      "petId": petId,
      "petName": petName,
      "petOwnerId": petOwnerId,
      "petBuyerId": petBuyerId,
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "address": address,
      "message": message,
      "experience": experience,
      "status": status.name,
      "createdAt": createdAt,
    };
  }
}