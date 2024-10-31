import 'package:flutter/foundation.dart';
import 'package:storykuy/common/result_state.dart';
import 'package:storykuy/data/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository});

  ResultState _loginState = ResultState.initial;
  ResultState get loginState => _loginState;

  String _message = "";
  String get message => _message;

  Future<void> login(String email, String password) async {
    _loginState = ResultState.loading;
    notifyListeners();

    final response = await authRepository.login(email, password);
    if (response.loginResult != null && !response.error!) {
      _message = response.message!;
      _loginState = ResultState.loaded;
      notifyListeners();
    } else if (response.error! && response.message != null) {
      _message = response.message!;
      _loginState = ResultState.error;
      notifyListeners();
    } else {
      _loginState = ResultState.error;
      notifyListeners();
      _message = "Gagal terhubung dengan server!";
    }
  }
}
