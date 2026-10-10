import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env['BASE_URL'] ?? '';

  final String baseUrl;
  String? token;

  Map<String, String> _headers({bool withAuth = true}) {
    final h = <String, String>{'Content-Type': 'application/json'};
    if (withAuth && token != null) h['Authorization'] = 'Bearer $token';
    return h;
  }

  Uri _url(String path, [Map<String, String>? q]) =>
      Uri.parse('$baseUrl$path').replace(queryParameters: q);

  Future<http.Response> post(String path, {Object? body, bool auth = true}) {
    return http.post(_url(path), headers: _headers(withAuth: auth), body: body);
  }

  Future<http.Response> get(String path, {Map<String, String>? query}) {
    return http.get(_url(path, query), headers: _headers());
  }

  Future<http.Response> patch(String path, {Object? body}) {
    return http.patch(_url(path), headers: _headers(), body: body);
  }

  Future<http.Response> delete(String path) {
    return http.delete(_url(path), headers: _headers());
  }

  void clearToken() => token = null;
}
