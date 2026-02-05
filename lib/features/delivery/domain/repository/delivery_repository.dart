import '../../../../core/data/proof_attachment_entity.dart';
import '../entities/delivery_entity.dart';

abstract class DeliveryRepository {
  Future<DeliveryEntity> getDelivery(int id);

  Future<void> updateStatusDelivery(int id, String status);

  Future<String?> getDeliverySign({
    required int deliveryOrderId,
    required String type,
  });

  Future<List<ProofAttachmentEntity>> getDeliveryProofs(int deliveryOrderId);
}
