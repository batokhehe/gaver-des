class PickupSignParam {
  final int pickupOrderId;
  final String type;

  const PickupSignParam({required this.pickupOrderId, required this.type});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PickupSignParam &&
            pickupOrderId == other.pickupOrderId &&
            type == other.type;
  }

  @override
  int get hashCode => Object.hash(pickupOrderId, type);
}
