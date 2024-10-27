import 'package:flutter/material.dart';
import 'package:storykuy/presentation/splash_screen/ui/splash_screen_page.dart';

void main() {
  runApp(const StoryKuyApp());
}

class StoryKuyApp extends StatelessWidget {
  const StoryKuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoryKuy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreenPage(),
    );
  }
}
