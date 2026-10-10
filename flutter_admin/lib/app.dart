import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'features/auth/viewmodels/login_viewmodel.dart';
import 'routes/app_router.dart';

class TaskAdminApp extends StatelessWidget {
  const TaskAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiClient();

    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: api),
        ChangeNotifierProvider(create: (_) => LoginViewModel(api)),
      ],
      child: MaterialApp(
        title: 'Booking Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.login,
        routes: appRoutes,
      ),
    );
  }
}
