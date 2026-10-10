import 'package:flutter/material.dart';
import '../features/auth/views/login_view.dart';
import '../features/bookings/views/bookings_view.dart';
import '../features/catalog/views/services_view.dart';
import '../features/catalog/views/stylists_view.dart';
import '../features/shell/admin_shell.dart';

class Routes {
  static const login = '/';
  static const home = '/home';
  static const stylists = '/stylists';
  static const services = '/services';
}

final routes = <String, WidgetBuilder>{
  Routes.login: (_) => const LoginView(),
  Routes.home: (_) => const AdminShell(tab: 0, child: BookingsView()),
  Routes.stylists: (_) => const AdminShell(tab: 1, child: StylistsView()),
  Routes.services: (_) => const AdminShell(tab: 2, child: ServicesView()),
};
