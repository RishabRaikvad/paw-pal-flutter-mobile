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
}