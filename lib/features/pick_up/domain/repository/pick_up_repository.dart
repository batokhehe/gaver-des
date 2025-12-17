import '../entities/pick_up_entity.dart';

abstract class PickUpRepository {
  Future<PickUpEntity> getPickUp(int pickupId);
}
