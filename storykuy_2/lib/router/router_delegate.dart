import 'package:flutter/material.dart';
import 'package:storykuy/data/model/get_all_stories_response.dart';
import 'package:storykuy/data/repository/auth_repository.dart';
import 'package:storykuy/ui/screens/add_story_screen.dart';
import 'package:storykuy/ui/screens/home_screen.dart';
import 'package:storykuy/ui/screens/pick_location_screen.dart';
import 'package:storykuy/ui/screens/splash_screen.dart';
import 'package:storykuy/ui/screens/story_detail_screen.dart';

import '../ui/screens/login_screen.dart';
import '../ui/screens/register_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  MyRouterDelegate(
    this.authRepository,
  ) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  Story? selectedStory;
  bool addStory = false;
  bool pickLocation = false;

  _init() async {
    isLoggedIn = await authRepository.getSession() != null;
    notifyListeners();
  }

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashPage"),
          child: SplashScreen(),
        )
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
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
            key: const ValueKey("RegisterPage"),
            child: RegisterScreen(
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
              onRegister: () {
                isRegister = true;
                notifyListeners();
              },
            ),
          ),
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey("HomePage"),
          child: HomeScreen(
            onTapped: (Story story) {
              selectedStory = story;
              notifyListeners();
            },
            onLogout: () {
              isLoggedIn = false;
              notifyListeners();
            },
            onGoToAddScreen: () {
              addStory = true;
              notifyListeners();
            },
          ),
        ),
        if (selectedStory != null)
          MaterialPage(
            key: ValueKey(selectedStory),
            child: StoryDetailScreen(story: selectedStory!),
          ),
        if (addStory == true)
          MaterialPage(
            key: const ValueKey("AddStory"),
            child: AddStoryScreen(
              goBackToHome: () {
                addStory = false;
                notifyListeners();
              },
              goToPickLocation: () {
                pickLocation = true;
                notifyListeners();
              },
            ),
          ),
        if (pickLocation == true)
          MaterialPage(child: PickLocationScreen(
            onSetLocation: () {
              pickLocation = false;
              notifyListeners();
            },
          ))
      ];

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
        selectedStory = null;
        if (addStory == true && pickLocation == true) {
          pickLocation = false;
          notifyListeners();
          return true;
        }
        addStory = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}
