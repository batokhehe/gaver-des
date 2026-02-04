import 'dart:ui';

class TaskItem {
  final int id;
  final String code;
  final String hub;
  final String status;
  final Color statusColor;
  final int item;
  final String vendor;
  final String address;
  final String addressName;
  final String? pickupMapsOption;

  TaskItem({
    required this.id,
    required this.code,
    required this.hub,
    required this.status,
    required this.statusColor,
    required this.item,
    required this.vendor,
    required this.address,
    required this.addressName,
    this.pickupMapsOption,
  });
}
