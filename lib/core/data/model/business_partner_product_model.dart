class BusinessPartnerProduct {
  final int id;
  final int productId;
  final String code;
  final String name;
  final double kgPerCarton;

  BusinessPartnerProduct({
    required this.id,
    required this.productId,
    required this.code,
    required this.name,
    required this.kgPerCarton,
  });

  factory BusinessPartnerProduct.fromJson(Map<String, dynamic> json) {
    return BusinessPartnerProduct(
      id: json['id'],
      productId: json['productId'],
      code: json['product']['code'],
      name: json['product']['name'],
      kgPerCarton: (json['product']['kgActualPerCarton'] as num).toDouble(),
    );
  }
}
