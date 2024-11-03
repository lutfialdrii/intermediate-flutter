import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storykuy/common/handle_dio.dart';
import 'package:storykuy/data/dio/dio_service.dart';
import 'package:storykuy/data/model/general_response.dart';
import 'package:storykuy/data/model/login_response.dart';

class AuthRepository {
  final DioService dioService;
  static const String sessionKey = 'sessionKey';

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
    } on DioException catch (e) {
      // Tangani DioException
      throw handleDioError(e);
    }
  }

  Future<GeneralResponse> register(
      String name, String email, String password) async {
    try {
      final response = await dioService.register(name, email, password);
      return response;
    } on DioException catch (e) {
      throw handleDioError(e);
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
      return false;
    }
  }

  Future<bool> clearSession() async {
    final preferences = await SharedPreferences.getInstance();
    try {
      return await preferences.remove(sessionKey);
    } catch (e) {
      return false;
    }
  }

  // Future<bool>
}
