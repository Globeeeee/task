import 'package:flutter/material.dart';
import '../features/auth/views/login_view.dart';
import '../features/shell/admin_shell.dart';

class Routes {
  static const login = '/';
  static const home = '/home';
}

final routes = <String, WidgetBuilder>{
  Routes.login: (_) => const LoginView(),
  '/login': (_) => const LoginView(),
  Routes.home: (_) => const AdminShell(),
  '/bookings': (_) => const AdminShell(),
};
