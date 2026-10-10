import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/services_api.dart';
import 'item_list_page.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final api = context.read<ServicesApi>();
    return ItemListPage(
      title: 'Services',
      getAll: api.list,
      add: api.add,
      edit: api.edit,
      delete: api.delete,
    );
  }
}
