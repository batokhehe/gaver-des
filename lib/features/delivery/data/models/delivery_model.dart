import 'item_model.dart';

class DeliveryModel {
  final int id;
  final String code;
  final String hub;
  final String status;
  final DateTime deliveryDate;
  final String vendor;
  final String address;
  final String ownerSign;
  final String receiverSign;
  final String proof;
  final List<ItemModel> items;

  DeliveryModel({
    required this.id,
    required this.code,
    required this.hub,
    required this.status,
    required this.deliveryDate,
    required this.vendor,
    required this.address,
    required this.items,
    required this.ownerSign,
    required this.receiverSign,
    required this.proof,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'],
      code: json['codePko'] ?? '-',
      status: json['status'] ?? '-',
      hub: json['hubOption'] ?? '-',
      ownerSign: json['ownerSign'] ?? '-',
      receiverSign: json['receiverSign'] ?? '-',
      proof: json['proof'] ?? '-',
      deliveryDate: DateTime.parse(json['deliveryDate']),
      vendor: json['businessPartnerOption'] ?? '-',
      address: json['pickupAddressOption'] ?? '-',
      items: (json['items'] as List)
          .map((e) => ItemModel.fromJson(e))
          .toList(),
    );
  }
}
