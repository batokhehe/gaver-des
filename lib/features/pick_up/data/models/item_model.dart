class ItemModel {
  final int id;
  final String name;
  final int qty;
  final double weight;
  final String uom;

  ItemModel({
    required this.id,
    required this.name,
    required this.qty,
    required this.weight,
    required this.uom,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] ?? 0,
      name: json['product']?['name'] ?? '-',
      qty: json['qty'] ?? 0,
      weight: (json['actualKg'] as num?)?.toDouble() ?? 0,
      uom: json['uom']?['symbol'] ?? '-',
    );
  }
}
