import '../core/constant.dart';

class CartModel {
  final String cartId;
  final String productId;
  final String userId;
  final String productName;
  final double productPrice;
  final double unitPrice;
  int productQuantity;
  final String productMainImage;
  final String? variantTitle;
  final VariantType variantType;
  final DateTime createdAt;

  CartModel({
    required this.cartId,
    required this.productId,
    required this.userId,
    required this.productName,
    required this.productPrice,
    required this.unitPrice,
    required this.productQuantity,
    required this.productMainImage,
    this.variantTitle,
    required this.variantType,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "cartId": cartId,
      "productId": productId,
      "userId": userId,
      "productName": productName,
      "productPrice": productPrice,
      "unitPrice": unitPrice,
      "productQuantity": productQuantity,
      "productMainImage": productMainImage,
      "variantTitle": variantTitle,
      "variantType": variantType.name,
      "createdAt": createdAt,
    };
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json["cartId"] ?? "",
      productId: json["productId"] ?? "",
      userId: json["userId"] ?? "",
      productName: json["productName"] ?? "",
      productPrice: (json["productPrice"] ?? 0).toDouble(),
      unitPrice: (json["unitPrice"] ?? 0).toDouble(),
      productQuantity: (json["productQuantity"] ?? 1),
      productMainImage: json["productMainImage"] ?? "",
      variantTitle: json["variantTitle"] ?? "",
      variantType: VariantType.values.firstWhere(
        (e) => e.name == json["variantType"],
        orElse: () => VariantType.none,
      ),
      createdAt: json["createdAt"]?.toDate() ?? DateTime.now(),
    );
  }
}
