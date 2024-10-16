import 'package:flutter/material.dart';
import 'package:redirection_exercise/db/auth_repository.dart';

import '../model/quote.dart';
import '../screen/login_screen.dart';
import '../screen/quote_detail_screen.dart';
import '../screen/quotes_list_screen.dart';
import '../screen/register_screen.dart';
import '../screen/splash_screen.dart';

/// todo 1: create new class router-delegate
class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  /// todo 2: add navigator key,
  /// change other method, and
  /// add the variable to Navigator widget
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;

  MyRouterDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey('SplashPage'),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey('LoginPage'),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: ValueKey('RegisterPage'),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
          key: ValueKey('QuotesListPage'),
          child: QuotesListScreen(
            quotes: quotes,
            onTapped: (String quoteId) {
              selectedQuote = quoteId;
              notifyListeners();
            },
            onLogout: () {
              isLoggedIn = false;
              notifyListeners();
            },
          ),
        ),
        if (selectedQuote != null)
          MaterialPage(
            key: ValueKey(selectedQuote),
            child: QuoteDetailsScreen(quoteId: selectedQuote!),
          )
      ];

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// todo 3: move Navigator widget to build method,
  /// add selected quote variable,
  /// delete setState function, and
  /// change with notifiyListener().
  String? selectedQuote;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        isRegister = false;
        selectedQuote = null;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }
}
