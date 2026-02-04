import '../entities/delivery_entity.dart';

abstract class DeliveryRepository {
  Future<DeliveryEntity> getDelivery(int id);

  Future<void> updateStatusDelivery(int id, String status);

  Future<String?> getDeliverySign({
    required int deliveryOrderId,
    required String type,
  });
}
