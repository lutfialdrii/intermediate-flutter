import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:storykuy/data/dio/dio_service.dart';
import 'package:storykuy/data/model/login_response.dart';

class AuthRepository {
  final DioService dioService;
  final String sessionKey = 'sessionKey';

  AuthRepository({required this.dioService});

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await dioService.login(email, password);
      if (!response.error!) {
        saveSession(response);
        return response;
      } else {
        return response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getSession() async {
    final preferences = await SharedPreferences.getInstance();
    var rawData = preferences.getString(sessionKey);
    if (rawData == null) {
      return null;
    }
    return User.fromJson(jsonDecode(rawData));
  }

  Future<bool> saveSession(LoginResponse response) async {
    final preferences = await SharedPreferences.getInstance();
    try {
      return await preferences.setString(sessionKey, jsonEncode(response));
    } catch (e) {
      rethrow;
    }
  }

  // Future<bool>
}
