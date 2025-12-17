class TaskEntity {
  final int id;
  final String code;
  final String hub;
  final String status;
  final int itemCount;
  final String vendor;
  final String address;

  TaskEntity({
    required this.id,
    required this.code,
    required this.hub,
    required this.status,
    required this.itemCount,
    required this.vendor,
    required this.address,
  });
}
