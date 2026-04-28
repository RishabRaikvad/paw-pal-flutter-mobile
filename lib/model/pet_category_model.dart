import 'package:cloud_firestore/cloud_firestore.dart';

class PetCategoryModel {
  final String id;
  final String categoryName;
  final DateTime createdAt;

  PetCategoryModel({
    required this.id,
    required this.categoryName,
    required this.createdAt,
  });

  factory PetCategoryModel.fromJson(Map<String, dynamic> json,) {
    return PetCategoryModel(
      id: json['id'] ?? "",
      categoryName: json['categoryName'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'categoryName': categoryName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}