import '../../../core/network/api_client.dart';
import '../models/item.dart';

class ServicesApi {
  ServicesApi(this.api);
  final ApiClient api;

  Future<List<Item>> list() async {
    final res = await api.get('/services');
    if (res.statusCode != 200) {
      throw Exception(res.data['message'] ?? 'couldnt load services');
    }
    return (res.data['data'] as List)
        .map((e) => Item.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Item> add(String name) async {
    final res = await api.post('/services', body: {'name': name});
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(res.data['message'] ?? 'create failed');
    }
    return Item.fromJson(Map<String, dynamic>.from(res.data['data']));
  }

  Future<Item> edit(String id, String name) async {
    final res = await api.patch('/services/$id', body: {'name': name});
    if (res.statusCode != 200) {
      throw Exception(res.data['message'] ?? 'update failed');
    }
    return Item.fromJson(Map<String, dynamic>.from(res.data['data']));
  }

  Future<void> delete(String id) async {
    final res = await api.delete('/services/$id');
    if (res.statusCode != 200) {
      throw Exception(res.data['message'] ?? 'delete failed');
    }
  }
}
