import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/booking.dart';

class BookingTile extends StatelessWidget {
  const BookingTile({
    super.key,
    required this.booking,
    this.onConfirm,
    this.onCancel,
    this.onDelete,
  });

  final Booking booking;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final b = booking;

    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        title: Text(
          '${b.customerName} — ${b.serviceName}',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'stylist: ${b.stylistName}\n'
          'time: ${b.slotStart}\n'
          'status: ${b.status}',
          style: TextStyle(fontSize: 13.sp, height: 1.35),
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (b.pending) ...[
              FilledButton(
                onPressed: onConfirm,
                child: const Text('Confirm'),
              ),
              SizedBox(width: 8.w),
              OutlinedButton(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
              SizedBox(width: 8.w),
            ],
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
