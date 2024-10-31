import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storykuy/common/result_state.dart';
import 'package:storykuy/data/model/get_all_stories_response.dart';
import 'package:storykuy/provider/home_provider.dart';

import '../../provider/auth_provider.dart';
import '../widgets/card_story.dart';

class HomeScreen extends StatelessWidget {
  final Function() onLogout;
  final Function(Story) onTapped;

  const HomeScreen({super.key, required this.onLogout, required this.onTapped});

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
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('StoryKuy'),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(value: 0, child: Text('Logout')),
              const PopupMenuItem<int>(value: 1, child: Text('Settings')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Stack(
          children: [
            Consumer<HomeProvider>(
              builder: (context, provider, child) {
                if (provider.stories.isNotEmpty) {
                  return _buildList(provider);
                } else if (provider.stories.isEmpty) {
                  return Center(
                    child: Text("Saat ini tidak ada story yang dibagikan :("),
                  );
                }
                if (provider.state == ResultState.error &&
                    provider.message != "") {
                  return Center(
                    child: Text(provider.message),
                  );
                } else {
                  return Center(
                    child: Text(
                        "Terjadi kesalahan, periksa koneksi internet anda!"),
                  );
                }
              },
            ),
            if (authWatch.logoutState == ResultState.loading ||
                homeWatch.state == ResultState.loading)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }

  ListView _buildList(HomeProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: provider.stories.length,
      itemBuilder: (context, index) {
        final story = provider.stories[index];
        return CardStory(onTapped: onTapped, story: story);
      },
    );
  }
}