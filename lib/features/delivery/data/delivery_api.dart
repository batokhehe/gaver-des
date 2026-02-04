import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/errors/app_exception.dart';
import 'models/delivery_model.dart';
import 'models/order_proof_model.dart';

class DeliveryApi {
  final Dio dio;

  DeliveryApi(this.dio);

  Future<DeliveryModel> fetchDeliveryDetail(int id) async {
    final response = await dio.get('/delivery-orders/$id');

    return DeliveryModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<void> updateStatus(int id, String status) async {
    final response = await dio.put(
      '/delivery-orders/$id',
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
    await dio.post('/delivery-order-signs', data: body);
  }

  Future<void> uploadProof({
    required int deliveryOrderId,
    required String base64File,
  }) async {
    await dio.post(
      '/delivery-order-proofs',
      data: {"deliveryOrderId": deliveryOrderId, "file": base64File},
    );
  }

  Future<String?> fetchDeliverySign({
    required int deliveryOrderId,
    required String type, // owner | receiver | proof
    required String apiValue,
  }) async {
    final res = await dio.get(
      '/delivery-order-$apiValue/delivery-order/$deliveryOrderId',
      queryParameters: {'type': type},
    );

    final list = res.data['data'] as List;

    if (list.isEmpty) return null;

    return list.first['file']; // base64
  }

  Future<String> uploadFile(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    final res = await dio.post(
      '/uploads',
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );

    return res.data['data']['url']; // 🔥 URL S3
  }

  Future<OrderProofModel> submitDeliveryProof({
    required int deliveryOrderId,
    required String fileUrl,
    String type = 'attachment',
  }) async {
    final res = await dio.post(
      '/delivery-order-proofs',
      data: {'deliveryOrderId': deliveryOrderId, 'file': fileUrl, 'type': type},
    );

    return OrderProofModel.fromJson(res.data['data']);
  }
}
