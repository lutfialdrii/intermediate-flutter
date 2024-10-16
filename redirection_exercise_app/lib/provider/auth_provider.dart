import 'package:flutter/foundation.dart';
import 'package:redirection_exercise/db/auth_repository.dart';
import 'package:redirection_exercise/model/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository});

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedin = false;

  Future<bool> login(User user) async {
    isLoadingLogin = true;
    notifyListeners();

    final userState = await authRepository.getUser();
    if (user == userState) {
      await authRepository.login();
    }
    isLoggedin = await authRepository.isLoggedIn();

    isLoadingLogin = false;
    notifyListeners();

    return isLoggedin;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }

    isLoggedin = await authRepository.isLoggedIn();

    isLoadingLogout = false;
    notifyListeners();

    return !isLoggedin;
  }

  Future<bool> saveUser(User user) async {
    isLoadingRegister = true;
    notifyListeners();

    final userState = await authRepository.saveUser(user);
    isLoadingRegister = false;
    notifyListeners();

    return userState;
  }
}
