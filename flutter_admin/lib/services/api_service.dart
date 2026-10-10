import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../features/auth/models/admin_user.dart';
import '../features/bookings/models/booking.dart';

class ApiService {
  ApiService({String? baseUrl})
    : baseUrl = baseUrl ?? dotenv.env['BASE_URL'] ?? '';

  final String baseUrl;
  String? _token;

  String? get token => _token;

  void clearToken() {
    _token = null;
  }

  Map<String, String> _headers() {
    final map = <String, String>{'Content-Type': 'application/json'};
    if (_token != null) {
      map['Authorization'] = 'Bearer $_token';
    }
    return map;
  }

  // login api for admin
  Future<AdminUser> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final body = jsonDecode(res.body);
    if (res.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'login failed');
    }

    final user = AdminUser.fromJson(Map<String, dynamic>.from(body['data']));
    _token = user.token;
    return user;
  }

  //  get bookings
  Future<List<Booking>> fetchBookings({String? status}) async {
    var url = '$baseUrl/admin/bookings';
    if (status != null && status.isNotEmpty) {
      url += '?status=$status';
    }
    final res = await http.get(Uri.parse(url), headers: _headers());
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

  // update booking status
  Future<void> updateBookingStatus(String id, String status) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/admin/bookings/$id/status'),
      headers: _headers(),
      body: jsonEncode({'status': status}),
    );
    if (res.statusCode != 200) {
      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'update failed');
    }
  }
}
