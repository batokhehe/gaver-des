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
    required super.addressName,
    required super.pickupDate,
    super.mapsOption,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      code: json['codePko'] ?? json['codeDo'] ?? '-',
      hub: json['hubOption'] ?? json['hubOriginOption'] ?? '-',
      status: json['status'] ?? '-',
      itemCount: (json['items'] as List?)?.length ?? 0,
      vendor: json['businessPartnerOption'] ?? json['areaOption'] ?? '-',
      address: json['pickupAddressOption'] ?? json['deliveryAddress'] ?? '-',
      addressName:
          json['pickupAddressName'] ?? json['deliveryAddressName'] ?? '-',
      mapsOption: json['pickupMapsOption'] ?? json['deliveryMapsOption'],
      pickupDate: json['pickupDate'] != null
          ? DateTime.parse(json['pickupDate'])
          : DateTime.now(),
    );
  }
}
