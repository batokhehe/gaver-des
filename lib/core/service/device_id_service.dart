import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceIdService {
  final _storage = const FlutterSecureStorage();
  final _uuid = const Uuid();

  static const _key = "device_id";

  Future<String> getDeviceId() async {
    String? id = await _storage.read(key: _key);

    if (id != null) return id;

    id = _uuid.v4();
    await _storage.write(key: _key, value: id);

    return id;
  }
}
