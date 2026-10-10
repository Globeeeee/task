import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/stylist_api.dart';
import 'item_list_page.dart';

class StylistsView extends StatelessWidget {
  const StylistsView({super.key});

  @override
  Widget build(BuildContext context) {
    final api = context.read<StylistApi>();
    return ItemListPage(
      title: 'Stylists',
      getAll: api.list,
      add: api.add,
      edit: api.edit,
      delete: api.delete,
    );
  }
}
