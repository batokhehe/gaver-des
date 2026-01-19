import 'package:dio/dio.dart';

import '../../../core/errors/app_exception.dart';
import 'models/delivery_model.dart';

class DeliveryApi {
  final Dio dio;

  DeliveryApi(this.dio);

  Future<DeliveryModel> fetchDeliveryDetail(int id) async {
    final response = await dio.get('/deliveries/$id');

    return DeliveryModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<void> updateStatus(int id, String status) async {
    final response = await dio.put('/deliveries/$id', data: {'status': status});
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
    await dio.post('/delivery-signs', data: body);
  }

  Future<void> uploadProof({
    required int deliveryOrderId,
    required String base64File,
  }) async {
    await dio.post(
      '/delivery-proofs',
      data: {"deliveryOrderId": deliveryOrderId, "file": base64File},
    );
  }
}
