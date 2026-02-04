class DeliverySignParam {
  final int deliveryOrderId;
  final String type;

  const DeliverySignParam({required this.deliveryOrderId, required this.type});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DeliverySignParam &&
            deliveryOrderId == other.deliveryOrderId &&
            type == other.type;
  }

  @override
  int get hashCode => Object.hash(deliveryOrderId, type);
}
