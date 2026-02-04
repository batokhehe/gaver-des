import 'item_entity.dart';

class DeliveryEntity {
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
  final List<ItemEntity> items;
  final int businessPartnerId;

  const DeliveryEntity({
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
  });
}
