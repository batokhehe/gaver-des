import 'dart:ui';

class TaskItem {
  final String code;
  final String hub;
  final String status;
  final Color statusColor;
  final int item;
  final String vendor;
  final String address;

  TaskItem({
    required this.code,
    required this.hub,
    required this.status,
    required this.statusColor,
    required this.item,
    required this.vendor,
    required this.address,
  });
}
