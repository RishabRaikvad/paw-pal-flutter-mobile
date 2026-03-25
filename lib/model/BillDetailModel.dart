class BillDetails {
  final double itemTotal;
  final double deliveryCharge;
  final double platformFee;
  final double gst;
  final double subTotal;
  final double total;

  BillDetails({
    required this.itemTotal,
    required this.deliveryCharge,
    required this.platformFee,
    required this.gst,
    required this.subTotal,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemTotal': itemTotal,
      'deliveryCharge': deliveryCharge,
      'platformFee': platformFee,
      'gst': gst,
      'subTotal': subTotal,
      'total': total,
    };
  }
  factory BillDetails.fromJson(Map<String, dynamic> json) {
    return BillDetails(
      itemTotal: (json['itemTotal'] ?? 0).toDouble(),
      deliveryCharge: (json['deliveryCharge'] ?? 0).toDouble(),
      platformFee: (json['platformFee'] ?? 0).toDouble(),
      gst: (json['gst'] ?? 0).toDouble(),
      subTotal: (json['subTotal'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}