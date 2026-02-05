import '../../../../core/data/proof_attachment_entity.dart';
import '../entities/pick_up_entity.dart';

abstract class PickUpRepository {
  Future<PickUpEntity> getPickUp(int id);

  Future<void> updateStatusPickUp(int id, String status);

  Future<String?> getPickupSign({
    required int pickupOrderId,
    required String type,
  });

  Future<List<ProofAttachmentEntity>> getPickupProofs(int pickupOrderId);
}
