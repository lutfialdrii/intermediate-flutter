import 'package:flutter/foundation.dart';
import 'package:storykuy/common/result_state.dart';
import 'package:storykuy/data/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository});

  ResultState _loginState = ResultState.initial;
  ResultState get loginState => _loginState;

  ResultState _registerState = ResultState.initial;
  ResultState get registerState => _registerState;

  ResultState _logoutState = ResultState.initial;
  ResultState get logoutState => _logoutState;

  String _message = "";
  String get message => _message;

  Future<void> login(String email, String password) async {
    _loginState = ResultState.loading;
    notifyListeners();

    try {
      final response = await authRepository.login(email, password);
      if (response.loginResult != null && !response.error!) {
        _message = response.message!;
        _loginState = ResultState.loaded;
      } else if (response.error! && response.message != null) {
        _message = response.message!;
        _loginState = ResultState.error;
      } else {
        _loginState = ResultState.error;
        _message = "Gagal terhubung dengan server!";
      }
    } catch (e) {
      _loginState = ResultState.error;
      _message = e.toString(); // Simpan pesan error dari Exception
    }
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    _registerState = ResultState.loading;
    notifyListeners();

    try {
      final response = await authRepository.register(email, password);
      if (!response.error!) {
        _registerState = ResultState.loaded;
        _message = response.message!;
      } else {
        _registerState = ResultState.error;
        _message = response.message ?? "Terjadi Kesalahan!";
      }
    } catch (e) {
      _registerState = ResultState.error;
      _message = e.toString();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _logoutState = ResultState.loading;
    notifyListeners();

    try {
      final status = await authRepository.clearSession();
      if (status) {
        _logoutState = ResultState.loaded;
        _message = "Logout Berhasil";
      } else {
        _logoutState = ResultState.error;
        _message = "Terjadi Kesalahan";
      }
    } catch (e) {
      _logoutState = ResultState.error;
      _message = e.toString();
    }
    notifyListeners();
  }
}
