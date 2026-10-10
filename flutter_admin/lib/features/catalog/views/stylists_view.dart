import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/stylist_service.dart';
import 'named_list_view.dart';

class StylistsView extends StatelessWidget {
  const StylistsView({super.key});

  @override
  Widget build(BuildContext context) {
    final api = context.read<StylistService>();
    return NamedListView(
      title: 'Stylists',
      load: api.list,
      create: api.create,
      update: api.update,
      remove: api.remove,
    );
  }
}
