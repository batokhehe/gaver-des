import 'package:gaver_des/features/pick_up/domain/entities/pick_up_entity.dart';

import '../repository/pick_up_repository.dart';

class GetPickupDetailUseCase {
  final PickUpRepository repository;

  GetPickupDetailUseCase(this.repository);

  Future<PickUpEntity> call(int id) {
    return repository.getPickUp(id);
  }
}
