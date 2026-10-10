import 'dart:convert';

import '../../../core/network/api_client.dart';
import '../models/admin_user.dart';

class AuthService {
  AuthService(this._client);

  final ApiClient _client;

  Future<AdminUser> login(String email, String password) async {
    final res = await _client.post(
      '/auth/login',
      auth: false,
      body: jsonEncode({'email': email, 'password': password}),
    );

    final body = jsonDecode(res.body);
    if (res.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'login failed');
    }

    final user = AdminUser.fromJson(Map<String, dynamic>.from(body['data']));
    _client.token = user.token;
    return user;
  }

  void logout() {
    _client.clearToken();
  }
}
