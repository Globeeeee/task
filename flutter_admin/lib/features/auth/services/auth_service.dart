import '../../../core/network/api_client.dart';
import '../models/admin_user.dart';

class AuthService {
  AuthService(this.api);
  final ApiClient api;

  Future<AdminUser> login(String email, String password) async {
    final res = await api.post(
      '/auth/login',
      auth: false,
      body: {'email': email, 'password': password},
    );

    final data = res.data;
    if (res.statusCode != 200 || data['success'] != true) {
      throw Exception(data['message'] ?? 'login failed');
    }

    final user = AdminUser.fromJson(Map<String, dynamic>.from(data['data']));
    api.token = user.token;
    return user;
  }

  void logout() {
    api.clearToken();
  }
}
