import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storykuy/data/model/general_response.dart';
import 'package:storykuy/data/model/get_all_stories_response.dart';
import 'package:storykuy/data/model/login_response.dart';
import 'package:storykuy/data/repository/auth_repository.dart';

class DioService {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1';
  final Dio _dio;

  DioService() : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Tambahkan token ke header Authorization jika tersedia
        final token = await _getToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) {
        // Tangani kesalahan
        handler.next(error);
      },
    ));
  }

  // Fungsi untuk mendapatkan token dari SharedPreferences
  Future<String?> _getToken() async {
    final pref = await SharedPreferences.getInstance();
    final session = pref.getString(AuthRepository.sessionKey);
    if (session != null) {
      final loginResponse = LoginResponse.fromJson(jsonDecode(session));
      return loginResponse.loginResult?.token;
    }
    return null;
  }

  // Fungsi umum untuk menangani error
  Exception _handleError(DioException error) {
    if (error.response != null && error.response!.data is Map) {
      final message = error.response!.data['message'] ?? 'Terjadi kesalahan';
      return Exception(message);
    }
    return Exception('Terjadi kesalahan jaringan');
  }

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {"email": email, "password": password},
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<GeneralResponse> register(String email, String password) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {"email": email, "password": password},
      );
      return GeneralResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<GetAllStoriesResponse> fetchAllStories() async {
    try {
      final response = await _dio.get('/stories');
      return GetAllStoriesResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
}
