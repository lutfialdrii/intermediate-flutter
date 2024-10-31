import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storykuy/presentation/authentication/provider/login_notifier.dart';
import 'package:storykuy/presentation/authentication/ui/login_page.dart';
import 'package:storykuy/presentation/home_screen/ui/home_screen_page.dart';
import 'package:storykuy/presentation/splash_screen/ui/splash_screen_page.dart';
import './di/dependency.dart' as di;

void main() {
  di.init();
  runApp(const StoryKuyApp());
}

class StoryKuyApp extends StatelessWidget {
  const StoryKuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              LoginNotifier(useCase: di.locator(), mapper: di.locator()),
        )
      ],
      child: MaterialApp(
        title: 'StoryKuy',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white),
        home: const SplashScreenPage(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case ('/'):
              return MaterialPageRoute(
                builder: (context) => const SplashScreenPage(),
              );
            case (HomeScreenPage.routeName):
              return MaterialPageRoute(
                builder: (context) => const HomeScreenPage(),
              );
            case (LoginPage.routeName):
              return MaterialPageRoute(
                builder: (context) => const LoginPage(),
              );
          }
          return null;
        },
        initialRoute: '/',
      ),
    );
  }
}
