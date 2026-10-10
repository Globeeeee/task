import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'features/auth/services/auth_service.dart';
import 'features/bookings/services/booking_service.dart';
import 'routes/app_router.dart';

class AdminApp extends StatefulWidget {
  const AdminApp({super.key});

  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  late final api = ApiClient();
  late final auth = AuthService(api);
  late final bookings = BookingService(api);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: api),
        Provider.value(value: auth),
        Provider.value(value: bookings),
      ],
      child: ScreenUtilInit(
        designSize: const Size(1440, 900),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          title: 'Admin Panel',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
          ),
          initialRoute: Routes.login,
          routes: routes,
        ),
      ),
    );
  }
}
