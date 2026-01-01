import 'package:dio/dio.dart';
import 'package:gaver_des/features/pick_up/data/models/pick_up_model.dart';

import '../../../core/errors/app_exception.dart';

class PickUpApi {
  final Dio dio;

  PickUpApi(this.dio);

  Future<PickupModel> fetchPickupDetail(int id) async {
    final response = await dio.get('/pickup-orders/$id');

    return PickupModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> updateStatus(int id, String status) async {
    final response = await dio.put(
      '/pickup-orders/$id',
      data: {'status': status},
    );
    if (response.statusCode != null && response.statusCode! >= 400) {
      final data = response.data;

      throw AppException(
        statusCode: response.statusCode!,
        message: data['message'] ?? 'Terjadi kesalahan',
        code: data['code'],
      );
    }
  }

  Future<void> uploadSignature(Map<String, dynamic> body) async {
    await dio.post('/pickup-order-signs', data: body);
  }

  Future<void> uploadProof({
    required int pickupOrderId,
    required String base64File,
  }) async {
    await dio.post(
      '/pickup-order-proofs',
      data: {"pickupOrderId": pickupOrderId, "file": base64File},
    );
  }
}
