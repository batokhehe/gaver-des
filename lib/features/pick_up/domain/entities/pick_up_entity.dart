import 'item_entity.dart';

class PickUpEntity {
  final int id;
  final String code;
  final String hub;
  final String status;
  final DateTime pickupDate;
  final String vendor;
  final String address;
  final String ownerSign;
  final String receiverSign;
  final String proof;
  final List<ItemEntity> items;
  final int businessPartnerId;

  const PickUpEntity({
    required this.id,
    required this.code,
    required this.hub,
    required this.status,
    required this.pickupDate,
    required this.vendor,
    required this.address,
    required this.items,
    required this.ownerSign,
    required this.receiverSign,
    required this.proof,
    required this.businessPartnerId,
  });
}
