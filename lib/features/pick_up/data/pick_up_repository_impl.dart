import 'package:gaver_des/features/pick_up/data/pick_up_api.dart';
import 'package:gaver_des/features/pick_up/data/pick_up_mapper.dart';

import '../domain/entities/pick_up_entity.dart';
import '../domain/repository/pick_up_repository.dart';

class PickUpRepositoryImpl implements PickUpRepository {
  final PickUpApi api;

  PickUpRepositoryImpl(this.api);

  @override
  Future<PickUpEntity> getPickUp(int id) async {
    final model = await api.fetchPickupDetail(id);
    return model.toEntity();
  }
}
