import 'package:cloud_firestore/cloud_firestore.dart';

enum AdoptionStatus { pending, approved, rejected,}

class AdoptionRequestModel {
  final String requestId;
  final String petId;
  final String petName;
  final String ownerName;
  final String ownerEmail;
  final String ownerPhone;
  final String ownerAddress;
  final String petBreed;
  final String petImage;
  final String petGender;
  final int petPrice;
  final String petAge;
  final String petOwnerId;   // from pet.ownerId
  final String petBuyerId;   // current user
  final String petOwnerProfileImage;   // from pet.ownerId
  final String petBuyerProfileImage;
  final String fullName;
  final String email;
  final String phone;
  final String message;
  final bool experience;
  final AdoptionStatus status;

  final DateTime createdAt;

  AdoptionRequestModel({
    required this.requestId,
    required this.petId,
    required this.petName,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.petBreed,
    required this.petImage,
    required this.petGender,
    required this.petPrice,
    required this.petAge,
    required this.petOwnerId,
    required this.petBuyerId,
    required this.petOwnerProfileImage,
    required this.petBuyerProfileImage,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.ownerAddress,
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
      ownerName: json['ownerName'] ?? '',
      ownerEmail: json['ownerEmail'] ?? '',
      ownerPhone: json['ownerPhone'] ?? '',
      ownerAddress: json['ownerAddress'] ?? '',
      petBreed: json['petBreed'] ?? '',
      petImage: json['petImage'] ?? '',
      petGender: json['petGender'] ?? '',
      petPrice: (json['petPrice'] is int)
          ? json['petPrice']
          : (json['petPrice'] as num?)?.toInt() ?? 0,
      petAge: json['petAge'] ?? '',
      petOwnerId: json['petOwnerId'] ?? '',
      petBuyerId: json['petBuyerId'] ?? '',
      petOwnerProfileImage: json['petOwnerProfileImage'] ?? '',
      petBuyerProfileImage: json['petBuyerProfileImage'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
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
      "ownerName": ownerName,
      "ownerEmail": ownerEmail,
      "ownerPhone": ownerPhone,
      "ownerAddress": ownerAddress,
      "petBreed": petBreed,
      "petImage": petImage,
      "petGender": petGender,
      "petPrice": petPrice,
      "petAge": petAge,
      "petOwnerId": petOwnerId,
      "petBuyerId": petBuyerId,
       "petOwnerProfileImage":petOwnerProfileImage,
      "petBuyerProfileImage":petBuyerProfileImage,
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "message": message,
      "experience": experience,
      "status": status.name,
      "createdAt": createdAt,
    };
  }
}