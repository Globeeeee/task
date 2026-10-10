import 'package:flutter/foundation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/utils/error_message.dart';
import '../../auth/services/auth_service.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';

class BookingsViewModel extends ChangeNotifier {
  BookingsViewModel(ApiClient client)
      : _bookings = BookingService(client),
        _auth = AuthService(client);

  final BookingService _bookings;
  final AuthService _auth;

  List<Booking> bookings = [];
  String filter = 'all';
  bool isLoading = false;
  String? error;
  String? actionError;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final status = filter == 'all' ? null : filter;
      bookings = await _bookings.fetchBookings(status: status);
    } catch (e) {
      error = errorMessage(e);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> setFilter(String value) async {
    filter = value;
    notifyListeners();
    await load();
  }

  Future<void> changeStatus(String id, String status) async {
    actionError = null;
    try {
      await _bookings.updateStatus(id, status);
      await load();
    } catch (e) {
      actionError = errorMessage(e);
      notifyListeners();
    }
  }

  void logout() {
    _auth.logout();
  }
}
