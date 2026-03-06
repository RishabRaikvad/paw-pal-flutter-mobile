import '../core/constant.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String categoryName;
  final String mainProductImage;
  final List<String> images;
  final bool isActive;
  final double basePrice;
  final String rating;
  final List<ProductVariant> variants;
  final VariantType variantType;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.mainProductImage,
    required this.images,
    required this.isActive,
    required this.basePrice,
    required this.rating,
    required this.variants,
    required this.variantType,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "categoryId": categoryId,
      "categoryName": categoryName,
      "mainProductImage": mainProductImage,
      "images": images,
      "isActive": isActive,
      "basePrice": basePrice,
      "rating": rating,
      "variants": variants.map((e) => e.toJson()).toList(),
      "variantType": variantType.name,
      "createdAt": createdAt,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      categoryId: json["categoryId"] ?? "",
      categoryName: json["categoryName"] ?? "",
      mainProductImage: json["mainProductImage"] ?? "",
      images: List<String>.from(json["images"] ?? []),
      isActive: json["isActive"] ?? true,
      basePrice: (json["basePrice"] ?? 0).toDouble(),
      rating: json["rating"] ?? "",
      variants: (json["variants"] as List<dynamic>? ?? [])
          .map((e) => ProductVariant.fromJson(e))
          .toList(),
      variantType: VariantType.values.firstWhere(
        (e) => e.name == json['variantType'],
        orElse: () => VariantType.none,
      ),
      createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  List<String> get getAllImages => [mainProductImage, ...images];
}

class ProductVariant {
  final String title;
  final double price;

  ProductVariant({required this.title, required this.price});

  Map<String, dynamic> toJson() {
    return {"title": title, "price": price};
  }

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      title: json["title"] ?? "",
      price: (json["price"] ?? 0).toDouble(),
    );
  }
}
