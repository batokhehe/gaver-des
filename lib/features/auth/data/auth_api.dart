import 'package:dio/dio.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Future<Map<String, dynamic>?> login(String email, String pass, String? fcmToken, String deviceId) async {
    final response = await dio.post(
      '/auth/login',
      data: {
        "email": email,
        "password": pass,
        "platform": "mobile",
        "fcmToken": fcmToken,
        "deviceId": deviceId,
      },
    );

    return response.data;
  }
}
