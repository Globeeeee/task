import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../models/booking.dart';

class BookingService {
  BookingService(this.api);
  final ApiClient api;

  Future<List<Booking>> list({String? status}) async {
    Map<String, String>? q;
    if (status != null && status.isNotEmpty) {
      q = {'status': status};
    }

    final res = await api.get('/admin/bookings', query: q);
    final data = jsonDecode(res.body);

    if (res.statusCode == 401) {
      throw Exception(data['message'] ?? 'missing token');
    }
    if (res.statusCode == 403) throw Exception('not admin');
    if (res.statusCode != 200) {
      throw Exception(data['message'] ?? 'couldnt load bookings');
    }

    final rows = data['data'] as List;
    return rows
        .map((e) => Booking.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> setStatus(String id, String status) async {
    final res = await api.patch(
      '/admin/bookings/$id/status',
      body: jsonEncode({'status': status}),
    );
    if (res.statusCode != 200) {
      final data = jsonDecode(res.body);
      throw Exception(data['message'] ?? 'update failed');
    }
  }
}
