import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/auth_api.dart';
import 'model/user_model.dart';

class AuthRepository {
  final AuthApi api;
  final storage = const FlutterSecureStorage();

  AuthRepository(this.api);

  Future<bool> login(String email, String pass) async {
    final res = await api.login(email, pass);

    if (res == null) return false;

    final token = res["token"];
    final userJson = res["data"];

    if (token == null || userJson == null) return false;

    final user = UserModel.fromJson(userJson);

    // Simpan ke secure storage
    await storage.write(key: "token", value: token);
    await storage.write(key: "name", value: user.name);
    await storage.write(key: "email", value: user.email);

    return true;
  }

  Future<String?> getToken() => storage.read(key: "token");

  Future<String?> getName() => storage.read(key: "name");

  Future<String?> getEmail() => storage.read(key: "email");

  Future<bool> isLoggedIn() async => (await getToken()) != null;

  Future<void> logout() async {
    await storage.delete(key: "token");
    await storage.delete(key: "name");
    await storage.delete(key: "email");
  }
}
