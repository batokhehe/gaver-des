class ItemEntity {
  final int id;
  String name;
  int qty;
  double weight;
  final double actualWeight;
  final String uom;
  final String productOption;

  ItemEntity({
    required this.id,
    required this.name,
    required this.qty,
    required this.weight,
    required this.actualWeight,
    required this.uom,
    required this.productOption,
  });
}
