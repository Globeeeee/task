import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../models/named_item.dart';

class StylistService {
  StylistService(this.api);
  final ApiClient api;

  Future<List<NamedItem>> list() async {
    final res = await api.get('/stylists');
    final data = jsonDecode(res.body);
    if (res.statusCode != 200) {
      throw Exception(data['message'] ?? 'couldnt load stylists');
    }
    final rows = data['data'] as List;
    return rows
        .map((e) => NamedItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<NamedItem> create(String name) async {
    final res = await api.post(
      '/stylists',
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
      '/stylists/$id',
      body: jsonEncode({'name': name}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode != 200) {
      throw Exception(data['message'] ?? 'update failed');
    }
    return NamedItem.fromJson(Map<String, dynamic>.from(data['data']));
  }

  Future<void> remove(String id) async {
    final res = await api.delete('/stylists/$id');
    if (res.statusCode != 200) {
      final data = jsonDecode(res.body);
      throw Exception(data['message'] ?? 'delete failed');
    }
  }
}
