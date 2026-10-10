import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/network/api_client.dart';
import '../features/auth/views/login_view.dart';
import '../features/bookings/viewmodels/bookings_viewmodel.dart';
import '../features/bookings/views/bookings_view.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginView(),
        );
      case AppRoutes.bookings:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            final api = context.read<ApiClient>();
            return ChangeNotifierProvider(
              create: (_) => BookingsViewModel(api)..load(),
              child: const BookingsView(),
            );
          },
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginView(),
        );
    }
  }

  static void goToBookings(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.bookings);
  }

  static void goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}
