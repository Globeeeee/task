import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/error_message.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/error_text.dart';
import '../models/named_item.dart';
import '../widgets/named_item_tile.dart';

typedef ListFn = Future<List<NamedItem>> Function();
typedef CreateFn = Future<NamedItem> Function(String name);
typedef UpdateFn = Future<NamedItem> Function(String id, String name);
typedef DeleteFn = Future<void> Function(String id);

class NamedListView extends StatefulWidget {
  const NamedListView({
    super.key,
    required this.title,
    required this.load,
    required this.create,
    required this.update,
    required this.remove,
  });

  final String title;
  final ListFn load;
  final CreateFn create;
  final UpdateFn update;
  final DeleteFn remove;

  @override
  State<NamedListView> createState() => _NamedListViewState();
}

class _NamedListViewState extends State<NamedListView> {
  List<NamedItem> items = [];
  bool loading = false;
  String? err;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => refresh());
  }

  Future<void> refresh() async {
    setState(() {
      loading = true;
      err = null;
    });
    try {
      final list = await widget.load();
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

  Future<void> _askName({NamedItem? existing}) async {
    final ctrl = TextEditingController(text: existing?.name ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Add ${widget.title}' : 'Edit ${widget.title}'),
        content: AppTextField(controller: ctrl, label: 'Name'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    final name = ctrl.text.trim();
    ctrl.dispose();
    if (ok != true || name.isEmpty || !mounted) return;

    try {
      if (existing == null) {
        await widget.create(name);
      } else {
        await widget.update(existing.id, name);
      }
      await refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(cleanErr(e))),
      );
    }
  }

  Future<void> _delete(NamedItem item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete?'),
        content: Text('Remove "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    try {
      await widget.remove(item.id);
      await refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(cleanErr(e))),
      );
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
              Text(
                widget.title,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                onPressed: loading ? null : refresh,
                icon: const Icon(Icons.refresh),
              ),
              SizedBox(width: 8.w),
              FilledButton.icon(
                onPressed: () => _askName(),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
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
                  child: Text('nothing here', style: TextStyle(fontSize: 15.sp)),
                )
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 24.h),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return NamedItemTile(
                      item: item,
                      onEdit: () => _askName(existing: item),
                      onDelete: () => _delete(item),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
