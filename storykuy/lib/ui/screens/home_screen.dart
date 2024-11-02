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

class HomeScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    final homeWatch = context.watch<HomeProvider>();

    Future<void> handleClick(int item) async {
      switch (item) {
        case 0:
          await authWatch.logout();
          if (authWatch.logoutState == ResultState.loaded) {
            onLogout();
          } else if (authWatch.logoutState == ResultState.error ||
              homeWatch.state == ResultState.error) {
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
                if (provider.stories.isNotEmpty) {
                  return _buildList(provider.stories);
                } else if (provider.stories.isEmpty &&
                    provider.state == ResultState.loaded) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.emptyStory),
                  );
                }
                if (provider.state == ResultState.error &&
                    provider.message != "") {
                  return Center(
                    child: Text(provider.message),
                  );
                }
                return const SizedBox();
              },
            ),
            if (authWatch.logoutState == ResultState.loading ||
                homeWatch.state == ResultState.loading)
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
          onGoToAddScreen();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void openLanguageSettings() {
    final intent = AndroidIntent(
      action: 'android.settings.LOCALE_SETTINGS',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }

  ListView _buildList(List<Story> stories) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return CardStory(onTapped: onTapped, story: story);
      },
    );
  }
}
