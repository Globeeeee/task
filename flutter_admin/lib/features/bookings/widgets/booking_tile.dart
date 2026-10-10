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
        title: Text(
          '${b.customerName} - ${b.serviceName}',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${b.stylistName}\n${b.slotStart}\n${b.status}',
          style: TextStyle(fontSize: 13.sp),
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (b.pending) ...[
              TextButton(onPressed: onConfirm, child: const Text('Confirm')),
              TextButton(onPressed: onCancel, child: const Text('Cancel')),
            ],
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
