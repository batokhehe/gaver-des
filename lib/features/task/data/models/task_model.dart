import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required super.id,
    required super.code,
    required super.hub,
    required super.status,
    required super.itemCount,
    required super.vendor,
    required super.address,
    required super.pickupDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      code: json['codePko'] ?? '-',
      hub: json['hubOption'] ?? '-',
      status: json['status'] ?? '-',
      itemCount: (json['items'] as List?)?.length ?? 0,
      vendor: json['businessPartnerOption'] ?? '-',
      address: json['businessPartnerAddressOption'] ?? '-',
      pickupDate: json['pickupDate'] != null
          ? DateTime.parse(json['pickupDate'])
          : DateTime.now(),
    );
  }
}
