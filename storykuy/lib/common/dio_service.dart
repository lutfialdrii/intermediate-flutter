import 'package:dio/dio.dart';

class DioService {
  final Dio dio;

  DioService({String baseUrl = 'https://story-api.dicoding.dev/v1'})
      : dio = Dio() {
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final response = await dio.get(endpoint, queryParameters: params);
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await dio.post(endpoint, data: data);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(Object e) {
    if (e is DioException) {
      print(e.message);
    } else {
      print('Something went wrong');
    }
  }
}
