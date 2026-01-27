import 'package:cloud_firestore/cloud_firestore.dart';

class PetCreationFeeModel {
  final String id;
  final String ownerId;
  final String petId;
  final double amount;
  final String currency;
  final String status;
  final String razorpayPaymentId;
  final DateTime createdAt;

  PetCreationFeeModel({
    required this.id,
    required this.ownerId,
    required this.petId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.razorpayPaymentId,
    required this.createdAt,
  });

  factory PetCreationFeeModel.fromMap(Map<String, dynamic> map) {
    return PetCreationFeeModel(
      id: map['feeId'],
      ownerId: map['ownerId'],
      petId: map['petId'],
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'],
      status: map['status'],
      razorpayPaymentId: map['razorpayPaymentId'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'feeId': id,
      'ownerId': ownerId,
      'petId': petId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'razorpayPaymentId': razorpayPaymentId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
