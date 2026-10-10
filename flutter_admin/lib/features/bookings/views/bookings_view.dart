import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/error_message.dart';
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/page_body.dart';
import '../../../routes/app_router.dart';
import '../../auth/services/auth_service.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';
import '../widgets/booking_tile.dart';

class BookingsView extends StatefulWidget {
  const BookingsView({super.key});

  @override
  State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> {
  List<Booking> items = [];
  String filter = 'all';
  bool loading = false;
  String? err;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => load());
  }

  Future<void> load() async {
    final api = context.read<ApiClient>();
    if (api.token == null || api.token!.isEmpty) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Routes.login);
      return;
    }

    setState(() {
      loading = true;
      err = null;
    });

    try {
      final status = filter == 'all' ? null : filter;
      final list = await context.read<BookingService>().list(status: status);
      if (!mounted) return;
      setState(() {
        items = list;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final msg = cleanErr(e);
      if (msg.contains('token') || msg.contains('unauthorized')) {
        Navigator.pushReplacementNamed(context, Routes.login);
        return;
      }
      setState(() {
        err = msg;
        loading = false;
      });
    }
  }

  Future<void> changeStatus(String id, String status) async {
    try {
      await context.read<BookingService>().setStatus(id, status);
      await load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(cleanErr(e))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel', style: TextStyle(fontSize: 20.sp)),
        actions: [
          IconButton(
            onPressed: loading ? null : load,
            icon: const Icon(Icons.refresh),
          ),
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
      body: PageBody(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 8.h),
              child: Row(
                children: [
                  Text(
                    'Bookings',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text('Filter', style: TextStyle(fontSize: 14.sp)),
                  SizedBox(width: 10.w),
                  DropdownButton<String>(
                    value: filter,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(value: 'pending', child: Text('Pending')),
                      DropdownMenuItem(
                        value: 'confirmed',
                        child: Text('Confirmed'),
                      ),
                      DropdownMenuItem(
                        value: 'cancelled',
                        child: Text('Cancelled'),
                      ),
                    ],
                    onChanged: loading
                        ? null
                        : (v) {
                            if (v == null) return;
                            setState(() => filter = v);
                            load();
                          },
                  ),
                ],
              ),
            ),
            if (loading) const LinearProgressIndicator(),
            if (err != null)
              Padding(
                padding: EdgeInsets.all(16.w),
                child: ErrorText(err!),
              ),
            Expanded(
              child: items.isEmpty && !loading
                  ? Center(
                      child: Text(
                        'nothing here',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 24.h),
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        final b = items[i];
                        return BookingTile(
                          booking: b,
                          onConfirm: () => changeStatus(b.id, 'confirmed'),
                          onCancel: () => changeStatus(b.id, 'cancelled'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
