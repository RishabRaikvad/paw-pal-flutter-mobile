import '../core/constant.dart';

class ProductCategoryModel {
  final String id;
  final String image;
  final String categoryName;
  final VariantType variantType;
  final DateTime createdAt;

  ProductCategoryModel({
    required this.id,
    required this.image,
    required this.categoryName,
    required this.variantType,
    required this.createdAt,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] ?? "",
      image: json['image'] ?? "",
      categoryName: json['categoryName'] ?? "",
      variantType: VariantType.values.firstWhere(
        (e) => e.name == json['variantType'],
        orElse: () => VariantType.none,
      ),
      createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image,
      "categoryName": categoryName,
      "variantType": variantType.name,
      "createdAt": createdAt,
    };
  }
}
