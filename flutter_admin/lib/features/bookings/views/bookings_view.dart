import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/error_message.dart';
import '../../../core/widgets/error_text.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';
import '../widgets/booking_tile.dart';

class BookingsView extends StatefulWidget {
  const BookingsView({super.key});

  @override
  State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> {
  var items = <Booking>[];
  var filter = 'all';
  var loading = false;
  String? err;

  BookingService get api => context.read<BookingService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => load());
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      err = null;
    });
    try {
      final list = await api.list(status: filter == 'all' ? null : filter);
      if (!mounted) return;
      setState(() {
        items = list;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        err = cleanErr(e);
        loading = false;
      });
    }
  }

  Future<void> setStatus(String id, String status) async {
    try {
      await api.setStatus(id, status);
      await load();
    } catch (e) {
      if (mounted) _toast(cleanErr(e));
    }
  }

  Future<void> remove(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this booking?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await api.remove(id);
      await load();
    } catch (e) {
      if (mounted) _toast(cleanErr(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 8.h),
          child: Row(
            children: [
              Text('Bookings', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
              const Spacer(),
              DropdownButton<String>(
                value: filter,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
                  DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                ],
                onChanged: loading
                    ? null
                    : (v) {
                        if (v == null) return;
                        setState(() => filter = v);
                        load();
                      },
              ),
              IconButton(onPressed: loading ? null : load, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
        if (loading) const LinearProgressIndicator(),
        if (err != null) Padding(padding: EdgeInsets.all(16.w), child: ErrorText(err!)),
        Expanded(
          child: items.isEmpty && !loading
              ? Center(child: Text('nothing here', style: TextStyle(fontSize: 15.sp)))
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 24.h),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final b = items[i];
                    return BookingTile(
                      booking: b,
                      onConfirm: () => setStatus(b.id, 'confirmed'),
                      onCancel: () => setStatus(b.id, 'cancelled'),
                      onDelete: () => remove(b.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
