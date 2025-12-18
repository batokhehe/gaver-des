class ItemEntity {
  final int id;
  final String name;
  final int qty;
  final double weight;
  final double actualWeight;
  final String uom;
  final String productOption;


  const ItemEntity({
    required this.id,
    required this.name,
    required this.qty,
    required this.weight,
    required this.actualWeight,
    required this.uom,
    required this.productOption,
  });
}
