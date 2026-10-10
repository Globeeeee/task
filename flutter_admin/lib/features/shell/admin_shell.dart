import 'package:flutter/material.dart';
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

  Widget _page() {
    if (tab == 1) return const StylistsView();
    if (tab == 2) return const ServicesView();
    return const BookingsView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        actions: [
          TextButton(
            onPressed: () {
              context.read<AuthService>().logout();
              Navigator.pushReplacementNamed(context, Routes.login);
            },
            child: const Text('log out'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: tab,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (i) {
              setState(() => tab = i);
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.calendar_today),
                label: Text('Bookings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Stylists'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.cut),
                label: Text('Services'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: PageBody(child: _page())),
        ],
      ),
    );
  }
}
