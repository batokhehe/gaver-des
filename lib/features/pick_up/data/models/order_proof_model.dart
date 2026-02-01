class OrderProofModel {
  final int id;
  final int? deliveryOrderId;
  final int? pickupOrderId;
  final String file;
  final String type;
  final DateTime createdAt;

  OrderProofModel({
    required this.id,
    this.deliveryOrderId,
    this.pickupOrderId,
    required this.file,
    required this.type,
    required this.createdAt,
  });

  factory OrderProofModel.fromJson(Map<String, dynamic> json) {
    return OrderProofModel(
      id: json['id'],
      deliveryOrderId: json['deliveryOrderId'],
      pickupOrderId: json['pickupOrderId'],
      file: json['file'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
