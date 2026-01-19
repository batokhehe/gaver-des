import 'package:gaver_des/features/delivery/domain/entities/delivery_entity.dart';

abstract class DeliveryRepository {
  Future<DeliveryEntity> getDelivery(int id);

  Future<void> updateStatusDelivery(int id, String status);
}
