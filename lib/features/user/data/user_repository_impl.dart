import 'package:gaver_des/features/user/data/user_api.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApi api;

  UserRepositoryImpl(this.api);

  @override
  Future<void> updateStatusUser(int id, String status) async {
    await api.updateStatus(id, status);
  }
}
