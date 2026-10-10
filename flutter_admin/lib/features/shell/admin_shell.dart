import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/network/api_client.dart';
import '../../core/widgets/page_body.dart';
import '../../routes/app_router.dart';
import '../auth/services/auth_service.dart';
import '../bookings/views/bookings_view.dart';
import '../catalog/views/services_view.dart';
import '../catalog/views/stylists_view.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.read<ApiClient>().token == null) {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (tab == 1) {
      body = const StylistsView();
    } else if (tab == 2) {
      body = const ServicesView();
    } else {
      body = const BookingsView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel', style: TextStyle(fontSize: 20.sp)),
        actions: [
          TextButton(
            onPressed: () {
              context.read<AuthService>().logout();
              Navigator.pushReplacementNamed(context, Routes.login);
            },
            child: const Text('Logout'),
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: tab,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (i) => setState(() => tab = i),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_today),
                label: Text('Bookings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('Stylists'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.cut_outlined),
                selectedIcon: Icon(Icons.cut),
                label: Text('Services'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: PageBody(child: body)),
        ],
      ),
    );
  }
}
