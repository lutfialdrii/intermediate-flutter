import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storykuy/data/model/get_all_stories_response.dart';
import 'package:storykuy/data/model/login_response.dart';
import 'package:storykuy/data/repository/auth_repository.dart';

class DioService {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<LoginResponse> login(String email, String password) async {
    final dio = Dio();
    final response = await dio.post(
      '$baseUrl/login',
      data: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(response.data);
    } else {
      throw Exception('Login gagal : ${response.data['message']}');
    }
  }

  Future<GetAllStoriesResponse> fetchAllStories() async {
    final pref = await SharedPreferences.getInstance();
    final session = pref.getString(AuthRepository.sessionKey);
    final token = LoginResponse.fromJson(jsonDecode(session!)).loginResult!.token;
    final dio = Dio(BaseOptions(headers: {"Authorization": "Bearer $token"}));

    final response = await dio.get('$baseUrl/stories');
    if (response.statusCode == 200) {
      return GetAllStoriesResponse.fromJson(response.data);
    } else {
      throw Exception('Gagal Mendapatkan Data : ${response.data['message']}');
    }

    // Register

    // Upload Story

    // Get Story

    // logout
  }
}
