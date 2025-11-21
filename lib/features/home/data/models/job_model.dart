class JobModel {
  final String id;
  final String title;
  final String address;
  final String? type;
  final int? itemCount;
  final bool isActive;

  JobModel({
    required this.id,
    required this.title,
    required this.address,
    this.type,
    this.itemCount,
    this.isActive = false,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
    id: json["id"],
    title: json["title"],
    address: json["address"],
    type: json["type"],
    itemCount: json["itemCount"],
    isActive: json["isActive"] ?? false,
  );
}
