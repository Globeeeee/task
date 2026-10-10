import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/network/api_client.dart';
import '../features/auth/views/login_view.dart';
import '../features/bookings/viewmodels/bookings_viewmodel.dart';
import '../features/bookings/views/bookings_view.dart';

class AppRoutes {
  static const login = '/login';
  static const bookings = '/bookings';
}

Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.login: (context) => const LoginView(),
  AppRoutes.bookings: (context) {
    var api = Provider.of<ApiClient>(context, listen: false);
    return ChangeNotifierProvider(
      create: (context) => BookingsViewModel(api)..load(),
      child: const BookingsView(),
    );
  },
};
