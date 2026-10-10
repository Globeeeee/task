import 'package:flutter/material.dart';

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
  String? error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => load());
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      error = null;
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
        error = cleanErr(e);
        loading = false;
      });
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<bool> _ask(String title, {Widget? body}) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: body,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return ok == true;
  }

  Future<void> _save({Item? old}) async {
    final con = TextEditingController(text: old?.name ?? '');
    final ok = await _ask(
      old == null ? 'Add' : 'Edit',
      body: AppTextField(controller: con, label: 'Name'),
    );
    final name = con.text.trim();
    con.dispose();
    if (!ok || name.isEmpty || !mounted) return;

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
    if (!await _ask('Delete ${item.name}?') || !mounted) return;
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
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Row(
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: loading ? null : load,
                icon: const Icon(Icons.refresh),
              ),
              ElevatedButton(
                onPressed: () => _save(),
                child: const Text('Add'),
              ),
            ],
          ),
        ),
        if (loading) const LinearProgressIndicator(),
        if (error != null)
          Padding(padding: const EdgeInsets.all(16), child: ErrorText(error!)),
        Expanded(
          child: items.isEmpty && !loading
              ? const Center(child: Text('empty'))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return ItemTile(
                      item: item,
                      onEdit: () => _save(old: item),
                      onDelete: () => _remove(item),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
