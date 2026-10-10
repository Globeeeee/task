import '../../../core/network/api_client.dart';
import '../models/booking.dart';

class BookingService {
  BookingService(this.api);
  final ApiClient api;

  Future<List<Booking>> list({String? status}) async {
    Map<String, dynamic>? query;
    if (status != null && status.isNotEmpty) {
      query = {'status': status};
    }

    final res = await api.get('/admin/bookings', query: query);
    final data = res.data;

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

  Future<void> create({
    required String customerName,
    required String stylistId,
    required String serviceId,
    required String slotStart,
  }) async {
    final res = await api.post(
      '/bookings',
      body: {
        'customerName': customerName,
        'stylistId': stylistId,
        'serviceId': serviceId,
        'slotStart': slotStart,
      },
    );
    if (res.statusCode != 201) {
      throw Exception(res.data['message'] ?? 'booking failed');
    }
  }

  Future<void> setStatus(String id, String status) async {
    final res = await api.patch(
      '/admin/bookings/$id/status',
      body: {'status': status},
    );
    if (res.statusCode != 200) {
      throw Exception(res.data['message'] ?? 'update failed');
    }
  }

  Future<void> remove(String id) async {
    final res = await api.delete('/admin/bookings/$id');
    if (res.statusCode != 200) {
      throw Exception(res.data['message'] ?? 'delete failed');
    }
  }
}
