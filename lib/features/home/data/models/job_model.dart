import '../../domain/entities/job.dart';

class JobModel extends Job {
  JobModel({
    required super.id,
    required super.title,
    required super.address,
    super.type,
    super.itemCount,
    super.isActive,
    required super.code,
    required super.warehouseName,
    required super.warehouseAddress,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      title: json['title'],
      address: json['address'],
      type: json['type'],
      itemCount: json['item_count'],
      isActive: json['is_active'] ?? false,
      code: json['code'],
      warehouseName: json['warehouseName'],
      warehouseAddress: json['warehouseAddress'],
    );
  }
}
