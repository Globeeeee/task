import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  ApiClient({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env['BASE_URL'] ?? '' {
    dio = Dio(
      BaseOptions(
        baseUrl: this.baseUrl,
        headers: {'Content-Type': 'application/json'},
        validateStatus: (_) => true,
      ),
    );
  }

  final String baseUrl;
  late final Dio dio;
  String? token;

  Options _headers({bool auth = true}) {
    final headers = <String, dynamic>{};
    if (auth && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return Options(headers: headers);
  }

  Future<Response> post(String path, {Object? body, bool auth = true}) =>
      dio.post(path, data: body, options: _headers(auth: auth));

  Future<Response> get(String path, {Map<String, dynamic>? query}) =>
      dio.get(path, queryParameters: query, options: _headers());

  Future<Response> patch(String path, {Object? body}) =>
      dio.patch(path, data: body, options: _headers());

  Future<Response> delete(String path) =>
      dio.delete(path, options: _headers());

  void clearToken() => token = null;
}
