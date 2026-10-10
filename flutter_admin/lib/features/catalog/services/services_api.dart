import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../models/item.dart';

class ServicesApi {
  ServicesApi(this.api);
  final ApiClient api;

  Future<List<Item>> list() async {
    final res = await api.get('/services');
    final body = jsonDecode(res.body);
    if (res.statusCode != 200) {
      throw Exception(body['message'] ?? 'couldnt load services');
    }
    return (body['data'] as List)
        .map((e) => Item.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Item> add(String name) async {
    final res = await api.post('/services', body: jsonEncode({'name': name}));
    final body = jsonDecode(res.body);
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(body['message'] ?? 'create failed');
    }
    return Item.fromJson(Map<String, dynamic>.from(body['data']));
  }

  Future<Item> edit(String id, String name) async {
    final res =
        await api.patch('/services/$id', body: jsonEncode({'name': name}));
    final body = jsonDecode(res.body);
    if (res.statusCode != 200) {
      throw Exception(body['message'] ?? 'update failed');
    }
    return Item.fromJson(Map<String, dynamic>.from(body['data']));
  }

  Future<void> delete(String id) async {
    final res = await api.delete('/services/$id');
    if (res.statusCode != 200) {
      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'delete failed');
    }
  }
}
