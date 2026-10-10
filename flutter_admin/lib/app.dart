import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'features/auth/services/auth_service.dart';
import 'features/auth/views/login_view.dart';
import 'features/bookings/services/booking_service.dart';
import 'features/catalog/services/services_api.dart';
import 'features/catalog/services/stylist_api.dart';
import 'routes/app_router.dart';

class AdminApp extends StatefulWidget {
  const AdminApp({super.key});

  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  final api = ApiClient();
  late final auth = AuthService(api);
  late final bookings = BookingService(api);
  late final stylists = StylistApi(api);
  late final services = ServicesApi(api);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: api),
        Provider.value(value: auth),
        Provider.value(value: bookings),
        Provider.value(value: stylists),
        Provider.value(value: services),
      ],
      child: ScreenUtilInit(
        designSize: const Size(1440, 900),
        minTextAdapt: true,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          );
        },
        child: MaterialApp(
          title: 'Admin Panel',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
          ),
          initialRoute: Routes.login,
          routes: routes,
          onUnknownRoute: (_) =>
              MaterialPageRoute(builder: (_) => const LoginView()),
        ),
      ),
    );
  }
}
