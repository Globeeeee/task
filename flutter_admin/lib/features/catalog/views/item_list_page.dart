import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/error_message.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/error_text.dart';
import '../models/item.dart';
import '../widgets/item_tile.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({
    super.key,
    required this.title,
    required this.getAll,
    required this.add,
    required this.edit,
    required this.delete,
  });

  final String title;
  final Future<List<Item>> Function() getAll;
  final Future<Item> Function(String name) add;
  final Future<Item> Function(String id, String name) edit;
  final Future<void> Function(String id) delete;

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  var items = <Item>[];
  var loading = false;
  String? err;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => load());
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      err = null;
    });
    try {
      final data = await widget.getAll();
      if (!mounted) return;
      setState(() {
        items = data;
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

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _save({Item? old}) async {
    final ctrl = TextEditingController(text: old?.name ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(old == null ? 'Add' : 'Edit'),
        content: AppTextField(controller: ctrl, label: 'Name'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    final name = ctrl.text.trim();
    ctrl.dispose();
    if (ok != true || name.isEmpty || !mounted) return;

    try {
      if (old == null) {
        await widget.add(name);
      } else {
        await widget.edit(old.id, name);
      }
      await load();
    } catch (e) {
      if (mounted) _toast(cleanErr(e));
    }
  }

  Future<void> _remove(Item item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${item.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await widget.delete(item.id);
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
              Text(widget.title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
              const Spacer(),
              IconButton(onPressed: loading ? null : load, icon: const Icon(Icons.refresh)),
              FilledButton(onPressed: () => _save(), child: const Text('Add')),
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
                    final it = items[i];
                    return ItemTile(
                      item: it,
                      onEdit: () => _save(old: it),
                      onDelete: () => _remove(it),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
