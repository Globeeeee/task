import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_router.dart';
import '../viewmodels/bookings_viewmodel.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  Future<void> _status(BuildContext context, String id, String status) async {
    final vm = context.read<BookingsViewModel>();
    await vm.changeStatus(id, status);
    if (!context.mounted) return;
    if (vm.actionError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.actionError!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        actions: [
          IconButton(
            onPressed: vm.isLoading ? null : vm.load,
            icon: const Icon(Icons.refresh),
          ),
          TextButton(
            onPressed: () {
              vm.logout();
              AppRouter.goToLogin(context);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                const Text('Filter: '),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: vm.filter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
                    DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                  ],
                  onChanged: (v) {
                    if (v != null) vm.setFilter(v);
                  },
                ),
              ],
            ),
          ),
          if (vm.isLoading) const LinearProgressIndicator(),
          if (vm.error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(vm.error!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: vm.bookings.isEmpty && !vm.isLoading
                ? const Center(child: Text('No bookings'))
                : ListView.builder(
                    itemCount: vm.bookings.length,
                    itemBuilder: (context, i) {
                      final b = vm.bookings[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text('${b.customerName} — ${b.serviceName}'),
                          subtitle: Text(
                            'Stylist: ${b.stylistName}\n'
                            'Time: ${b.slotStart}\n'
                            'Status: ${b.status}',
                          ),
                          isThreeLine: true,
                          trailing: b.isPending
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          _status(context, b.id, 'confirmed'),
                                      child: const Text('Confirm'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          _status(context, b.id, 'cancelled'),
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
