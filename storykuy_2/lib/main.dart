import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storykuy/data/dio/dio_service.dart';
import 'package:storykuy/data/repository/auth_repository.dart';
import 'package:storykuy/data/repository/story_repository.dart';
import 'package:storykuy/provider/auth_provider.dart';
import 'package:storykuy/provider/home_provider.dart';
import 'package:storykuy/router/page_manager.dart';
import 'package:storykuy/router/router_delegate.dart';

import 'common/common.dart';

void main() {
  runApp(const StorykuyApp());
}

class StorykuyApp extends StatefulWidget {
  const StorykuyApp({super.key});

  @override
  State<StorykuyApp> createState() => _StorykuyAppState();
}

class _StorykuyAppState extends State<StorykuyApp> {
  late MyRouterDelegate myRouterDelegate;
  late AuthProvider authProvider;
  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository(dioService: DioService());
    authProvider = AuthProvider(authRepository: authRepository);

    myRouterDelegate = MyRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => authProvider,
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(StoryRepository(
            dioService: DioService(),
          )),
        ),
        ChangeNotifierProvider(
          create: (context) => PageManager(),
        )
      ],
      child: MaterialApp(
        title: 'StoryKuy',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: Router(
          routerDelegate: myRouterDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
