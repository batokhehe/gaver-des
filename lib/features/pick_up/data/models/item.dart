import 'dart:ui';

class Item {
  final String code;
  final String name;
  final String status;
  final Color statusColor;
  final String total;
  final String weight;

  Item({
    required this.code,
    required this.name,
    required this.status,
    required this.statusColor,
    required this.total,
    required this.weight,
  });
}
