import 'package:flutter/material.dart';
import '../features/auth/views/login_view.dart';
import '../features/bookings/views/bookings_view.dart';

class Routes {
  static const login = '/login';
  static const bookings = '/bookings';
}

final routes = <String, WidgetBuilder>{
  Routes.login: (_) => const LoginView(),
  Routes.bookings: (_) => const BookingsView(),
};
