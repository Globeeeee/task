import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/service_catalog.dart';
import 'named_list_view.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final api = context.read<ServiceCatalog>();
    return NamedListView(
      title: 'Services',
      load: api.list,
      create: api.create,
      update: api.update,
      remove: api.remove,
    );
  }
}
