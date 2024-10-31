import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:storykuy/data/model/login_response.dart';

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

  // Register

  // Upload Story

  // Get Story

  // logout
}
