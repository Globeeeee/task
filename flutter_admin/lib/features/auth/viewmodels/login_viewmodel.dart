import 'package:flutter/foundation.dart';

import '../../../core/utils/error_message.dart';
import '../../../core/network/api_client.dart';
import '../models/admin_user.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(ApiClient client) : _auth = AuthService(client);

  final AuthService _auth;

  bool isLoading = false;
  String error = '';
  AdminUser? user;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      user = await _auth.login(email.trim(), password);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = errorMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
