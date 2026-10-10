import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../models/named_item.dart';

class ServiceCatalog {
  ServiceCatalog(this.api);
  final ApiClient api;

  Future<List<NamedItem>> list() async {
    final res = await api.get('/services');
    final data = jsonDecode(res.body);
    if (res.statusCode != 200) {
      throw Exception(data['message'] ?? 'couldnt load services');
    }
    final rows = data['data'] as List;
    return rows
        .map((e) => NamedItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<NamedItem> create(String name) async {
    final res = await api.post(
      '/services',
      body: jsonEncode({'name': name}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception(data['message'] ?? 'create failed');
    }
    return NamedItem.fromJson(Map<String, dynamic>.from(data['data']));
  }

  Future<NamedItem> update(String id, String name) async {
    final res = await api.patch(
      '/services/$id',
      body: jsonEncode({'name': name}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode != 200) {
      throw Exception(data['message'] ?? 'update failed');
    }
    return NamedItem.fromJson(Map<String, dynamic>.from(data['data']));
  }

  Future<void> remove(String id) async {
    final res = await api.delete('/services/$id');
    if (res.statusCode != 200) {
      final data = jsonDecode(res.body);
      throw Exception(data['message'] ?? 'delete failed');
    }
  }
}
