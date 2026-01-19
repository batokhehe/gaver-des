import 'package:dio/dio.dart';

import '../../../core/errors/app_exception.dart';

class UserApi {
  final Dio dio;

  UserApi(this.dio);

  Future<Map<String, dynamic>?> current() async {
    final response = await dio.get('/auth/current');

    return response.data;
  }

  Future<void> updateStatus(String status) async {
    final response = await dio.post(
      '/auth/changestatus',
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
}
