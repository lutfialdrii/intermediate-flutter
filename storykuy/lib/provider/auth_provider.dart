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
        _message = "Failed to connect to server!";
      }
    } catch (e) {
      _loginState = ResultState.error;
      _message = e.toString();
    }
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    _registerState = ResultState.loading;
    notifyListeners();

    try {
      final response = await authRepository.register(name, email, password);
      if (!response.error!) {
        _registerState = ResultState.loaded;
        _message = response.message!;
      } else {
        _registerState = ResultState.error;
        _message = response.message ?? "Something went wrong!!";
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
        _message = "Logout Success";
      } else {
        _logoutState = ResultState.error;
        _message = "Something went wrong!";
      }
    } catch (e) {
      _logoutState = ResultState.error;
      _message = e.toString();
    }
    notifyListeners();
  }
}
