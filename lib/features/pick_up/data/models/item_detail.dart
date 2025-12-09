class ItemDetail {
  final int? id;
  final String name;
  final int total;
  final double weight;
  bool checked;

  ItemDetail({
    this.id,
    required this.name,
    required this.total,
    required this.weight,
    this.checked = false,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) {
    return ItemDetail(
      id: json["id"],
      name: json["name"] ?? "",
      total: json["total"] is String
          ? int.tryParse(json["total"]) ?? 0
          : json["total"] ?? 0,
      weight: json["weight"] is String
          ? double.tryParse(json["weight"]) ?? 0
          : (json["weight"] ?? 0).toDouble(),
      checked: json["checked"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "total": total,
      "weight": weight,
      "checked": checked,
    };
  }

  ItemDetail copyWith({
    int? id,
    String? name,
    int? total,
    double? weight,
    bool? checked,
  }) {
    return ItemDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      total: total ?? this.total,
      weight: weight ?? this.weight,
      checked: checked ?? this.checked,
    );
  }
}
