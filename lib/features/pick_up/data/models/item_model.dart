class ItemModel {
  final int id;
  final String name;
  final int qty;
  final double weight;
  final String uom;
  final String productOption;
  final double actualWeight;

  ItemModel({
    required this.id,
    required this.name,
    required this.qty,
    required this.weight,
    required this.uom,
    required this.productOption,
    required this.actualWeight,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] ?? 0,
      name: json['product']?['name'] ?? '-',
      qty: json['qty'] ?? 0,
      weight: (json['actualKg'] as num?)?.toDouble() ?? 0,
      uom: json['uom']?['symbol'] ?? '-',
      productOption: json['productOption'] ?? '-',
      actualWeight: (json['actualKg'] as num?)?.toDouble() ?? 0,
    );
  }
}
