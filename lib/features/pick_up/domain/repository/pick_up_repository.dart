import '../entities/pick_up_entity.dart';

abstract class PickUpRepository {
  Future<PickUpEntity> getPickUp(int id);
  Future<void> updateStatusPickUp(int id, String status);
}
