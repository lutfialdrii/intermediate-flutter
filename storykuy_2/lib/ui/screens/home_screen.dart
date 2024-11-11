import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storykuy/common/result_state.dart';
import 'package:storykuy/data/model/get_all_stories_response.dart';
import 'package:storykuy/provider/home_provider.dart';
import '../../common/common.dart';
import '../../provider/auth_provider.dart';
import '../widgets/card_story.dart';

class HomeScreen extends StatefulWidget {
  final Function() onLogout;
  final Function(Story) onTapped;
  final Function() onGoToAddScreen;

  const HomeScreen({
    super.key,
    required this.onLogout,
    required this.onTapped,
    required this.onGoToAddScreen,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final homeProvider = context.read<HomeProvider>();
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent) {
          if (homeProvider.pageItems != null) {
            homeProvider.fetchStories();
          }
        }
      },
    );
    Future.microtask(() async => homeProvider.fetchStories());
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();

    Future<void> handleClick(int item) async {
      switch (item) {
        case 0:
          await authWatch.logout();
          if (authWatch.logoutState == ResultState.loaded) {
            widget.onLogout();
          } else if (authWatch.logoutState == ResultState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authWatch.message),
              ),
            );
          }
        case 1:
          if (Platform.isAndroid) {
            openLanguageSettings();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Language settings are only available on Android.'),
              ),
            );
          }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('StoryKuy'),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                  value: 0, child: Text(AppLocalizations.of(context)!.logout)),
              PopupMenuItem<int>(
                  value: 1,
                  child: Text(AppLocalizations.of(context)!.changeLanguage)),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            Consumer<HomeProvider>(
              builder: (context, provider, child) {
                if (provider.state == ResultState.loading &&
                    provider.pageItems == 1) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (provider.state == ResultState.loaded) {
                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: provider.stories.length +
                        (provider.pageItems != null ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == provider.stories.length &&
                          provider.pageItems != null) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final story = provider.stories[index];
                      return CardStory(onTapped: widget.onTapped, story: story);
                    },
                  );
                } else {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.emptyStory),
                  );
                }
              },
            ),
            if (authWatch.logoutState == ResultState.loading)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.1),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.onGoToAddScreen();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void openLanguageSettings() {
    const intent = AndroidIntent(
      action: 'android.settings.LOCALE_SETTINGS',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }
}
