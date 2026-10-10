import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_client.dart';
import '../../core/widgets/page_body.dart';
import '../../routes/app_router.dart';
import '../auth/services/auth_service.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key, required this.tab, required this.child});

  final int tab;
  final Widget child;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
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

  void _open(int i) {
    if (i == widget.tab) return;
    final name = switch (i) {
      1 => Routes.stylists,
      2 => Routes.services,
      _ => Routes.home,
    };
    Navigator.pushReplacementNamed(context, name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: false,
        centerTitle: false,
        titleSpacing: 16,
        title: Row(
          children: [
            const Text('Admin'),
            const Spacer(),
            TextButton(
              onPressed: () {
                context.read<AuthService>().logout();
                Navigator.pushReplacementNamed(context, Routes.login);
              },
              child: const Text('log out'),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: widget.tab,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: _open,
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
          Expanded(child: PageBody(child: widget.child)),
        ],
      ),
    );
  }
}
