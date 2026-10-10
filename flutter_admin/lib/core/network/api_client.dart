import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../utils/app_constants.dart';

class ApiClient {
  ApiClient({String? baseUrl})
      : baseUrl = baseUrl ??
            dotenv.env['BASE_URL'] ??
            dotenv.env['API_BASE'] ??
            AppConstants.defaultBaseUrl;

  final String baseUrl;
  String? token;

  Map<String, String> headers({bool auth = true}) {
    final map = <String, String>{'Content-Type': 'application/json'};
    if (auth && token != null) {
      map['Authorization'] = 'Bearer $token';
    }
    return map;
  }

  Uri uri(String path, [Map<String, String>? query]) {
    return Uri.parse('$baseUrl$path').replace(queryParameters: query);
  }

  Future<http.Response> post(String path, {Object? body, bool auth = true}) {
    return http.post(uri(path), headers: headers(auth: auth), body: body);
  }

  Future<http.Response> get(String path, {Map<String, String>? query}) {
    return http.get(uri(path, query), headers: headers());
  }

  Future<http.Response> patch(String path, {Object? body}) {
    return http.patch(uri(path), headers: headers(), body: body);
  }

  void clearToken() {
    token = null;
  }
}
