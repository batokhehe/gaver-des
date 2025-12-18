import 'package:dio/dio.dart';
import 'package:gaver_des/features/pick_up/data/models/pick_up_model.dart';

class PickUpApi {
  final Dio dio;

  PickUpApi(this.dio);

  Future<PickupModel> fetchPickupDetail(int id) async {
    final response = await dio.get('/pickup-orders/$id');

    return PickupModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> updateStatus(int id, String status) async {
    await dio.put('/pickup-orders/$id', data: {'status': status});
  }
}
