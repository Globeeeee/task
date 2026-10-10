import 'dart:convert';

import '../../../core/network/api_client.dart';
import '../models/booking.dart';

class BookingService {
  BookingService(this._client);

  final ApiClient _client;

  Future<List<Booking>> fetchBookings({String? status}) async {
    final query = <String, String>{};
    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }

    final res = await _client.get(
      '/admin/bookings',
      query: query.isEmpty ? null : query,
    );
    final body = jsonDecode(res.body);

    if (res.statusCode == 403) throw Exception('not admin');
    if (res.statusCode != 200) {
      throw Exception(body['message'] ?? 'could not load bookings');
    }

    final list = body['data'] as List<dynamic>;
    return list
        .map((e) => Booking.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> updateStatus(String id, String status) async {
    final res = await _client.patch(
      '/admin/bookings/$id/status',
      body: jsonEncode({'status': status}),
    );
    if (res.statusCode != 200) {
      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'update failed');
    }
  }
}
