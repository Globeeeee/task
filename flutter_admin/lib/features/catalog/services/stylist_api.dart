import '../../../core/network/api_client.dart';
import '../models/item.dart';

class StylistApi {
  StylistApi(this.api);
  final ApiClient api;

  Future<List<Item>> list() async {
    final res = await api.get('/stylists');
    final body = res.data;
    if (res.statusCode != 200) {
      throw Exception(body['message'] ?? 'couldnt load stylists');
    }
    return (body['data'] as List)
        .map((e) => Item.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Item> add(String name) async {
    final res = await api.post('/stylists', body: {'name': name});
    final body = res.data;
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(body['message'] ?? 'create failed');
    }
    return Item.fromJson(Map<String, dynamic>.from(body['data']));
  }

  Future<Item> edit(String id, String name) async {
    final res = await api.patch('/stylists/$id', body: {'name': name});
    if (res.statusCode != 200) {
      throw Exception(res.data['message'] ?? 'update failed');
    }
    return Item.fromJson(Map<String, dynamic>.from(res.data['data']));
  }

  Future<void> delete(String id) async {
    final res = await api.delete('/stylists/$id');
    if (res.statusCode != 200) {
      throw Exception(res.data['message'] ?? 'delete failed');
    }
  }
}
