import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_text_field.dart';
import '../../catalog/models/item.dart';

class CreateBookingResult {
  CreateBookingResult({
    required this.customerName,
    required this.stylistId,
    required this.serviceId,
    required this.slotStart,
  });

  final String customerName;
  final String stylistId;
  final String serviceId;
  final String slotStart;
}

class CreateBookingDialog extends StatefulWidget {
  const CreateBookingDialog({
    super.key,
    required this.stylists,
    required this.services,
  });

  final List<Item> stylists;
  final List<Item> services;

  @override
  State<CreateBookingDialog> createState() => _CreateBookingDialogState();
}

class _CreateBookingDialogState extends State<CreateBookingDialog> {
  final name = TextEditingController();
  final dayFmt = DateFormat('yyyy-MM-dd');
  final timeFmt = DateFormat('HH:mm');

  String? stylistId;
  String? serviceId;
  DateTime day = DateTime.now();
  String time = '10:00';

  List<String> get times {
    final list = <String>[];
    for (var h = 9; h <= 20; h++) {
      list.add(timeFmt.format(DateTime(2020, 1, 1, h, 0)));
      if (h < 20) list.add(timeFmt.format(DateTime(2020, 1, 1, h, 30)));
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    stylistId = widget.stylists.first.id;
    serviceId = widget.services.first.id;
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  Future<void> pickDay() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(day.year, day.month, day.day),
      firstDate: today,
      lastDate: DateTime(today.year + 1, today.month, today.day),
    );
    if (picked == null) return;
    setState(() => day = picked);
  }

  void submit() {
    final customer = name.text.trim();
    if (customer.isEmpty || stylistId == null || serviceId == null) return;

    final bits = time.split(':');
    final start = DateTime(
      day.year,
      day.month,
      day.day,
      int.parse(bits[0]),
      int.parse(bits[1]),
    );

    Navigator.pop(
      context,
      CreateBookingResult(
        customerName: customer,
        stylistId: stylistId!,
        serviceId: serviceId!,
        slotStart: start.toUtc().toIso8601String(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New booking'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(controller: name, label: 'Customer'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: stylistId,
                decoration: const InputDecoration(
                  labelText: 'Stylist',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final s in widget.stylists)
                    DropdownMenuItem(value: s.id, child: Text(s.name)),
                ],
                onChanged: (v) => setState(() => stylistId = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: serviceId,
                decoration: const InputDecoration(
                  labelText: 'Service',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final s in widget.services)
                    DropdownMenuItem(value: s.id, child: Text(s.name)),
                ],
                onChanged: (v) => setState(() => serviceId = v),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: pickDay,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(dayFmt.format(day)),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: time,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final t in times)
                    DropdownMenuItem(value: t, child: Text(t)),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => time = v);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: submit, child: const Text('Create')),
      ],
    );
  }
}
