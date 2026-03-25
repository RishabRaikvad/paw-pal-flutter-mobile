import 'package:paw_pal_mobile/model/BillDetailModel.dart';
import 'package:paw_pal_mobile/model/cart_model.dart';

enum OrderStatus { pending, delivered, cancel }
enum PaymentStatus { success, failed }

class OrderModel {
  final String orderId;
  final String userId;
  final List<CartModel> items;
  final BillDetails billing;
  final String paymentStatus;
  final OrderStatus orderStatus;
  final DateTime createdAt;
  final ShippingAddress shippingAddress;
  final String razorpayPaymentId;


  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.billing,
    required this.paymentStatus,
    required this.orderStatus,
    required this.createdAt,
    required this.shippingAddress,
    required this.razorpayPaymentId
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json["orderId"] ?? "",
      userId: json["userId"] ?? "",
      items: (json["items"] as List<dynamic>?)
          ?.map((item) => CartModel.fromJson(item))
          .toList() ??
          [],
      billing: BillDetails.fromJson(json["billing"] ?? {}),
      paymentStatus: json["paymentStatus"] ?? "",
      orderStatus: OrderStatus.values.firstWhere(
              (e) => e.name == json["orderStatus"],
          orElse: () => OrderStatus.pending),
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
      shippingAddress: ShippingAddress.fromJson(json["shippingAddress"] ?? {}),
      razorpayPaymentId: json["razorpayPaymentId"] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "userId": userId,
      "items": items.map((e) => e.toJson()).toList(),
      "billing": billing.toJson(),
      "paymentStatus": paymentStatus,
      "orderStatus": orderStatus.name,
      "createdAt": createdAt.toIso8601String(),
      "shippingAddress": shippingAddress.toJson(),
      "razorpayPaymentId":razorpayPaymentId
    };
  }
}

class ShippingAddress {
  final String name;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pinCode;

  ShippingAddress({
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pinCode,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      pinCode: json["pinCode"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "address": address,
      "city": city,
      "state": state,
      "pinCode": pinCode,
    };
  }
}