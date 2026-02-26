import 'item_model.dart';

class DeliveryModel {
  final int id;
  final String code;
  final String hub;
  final String status;
  final DateTime deliveryDate;
  final String vendor;
  final String address;
  final String addressName;
  final String ownerSign;
  final String receiverSign;
  final String proof;
  final int businessPartnerId;
  final String pickupMapsOption;
  final List<ItemModel> items;

  DeliveryModel({
    required this.id,
    required this.code,
    required this.hub,
    required this.status,
    required this.deliveryDate,
    required this.vendor,
    required this.address,
    required this.addressName,
    required this.items,
    required this.ownerSign,
    required this.receiverSign,
    required this.proof,
    required this.businessPartnerId,
    required this.pickupMapsOption,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'],
      code: json['codeDo'] ?? '-',
      status: json['status'] ?? '-',
      hub: json['hubOriginOption'] ?? '-',
      vendor: json['areaOption'] ?? '-',
      address: json['deliveryAddress'] ?? '-',
      addressName: json['deliveryAddressName'] ?? '-',
      ownerSign: json['ownerSign'] ?? '-',
      receiverSign: json['receiverSign'] ?? '-',
      proof: json['proof'] ?? '-',
      deliveryDate: DateTime.parse(json['deliveryOrderDate']),
      businessPartnerId: json['businessPartnerId'] ?? 0,
      pickupMapsOption: json['pickupMapsOption'] ?? "",
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => ItemModel.fromJson(e))
          .toList(),
    );
  }
}
