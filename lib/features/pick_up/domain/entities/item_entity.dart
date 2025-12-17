class ItemEntity {
  final int id;
  final String name;
  final int qty;
  final double weight;
  final String uom;

  const ItemEntity({
    required this.id,
    required this.name,
    required this.qty,
    required this.weight,
    required this.uom,
  });
}
