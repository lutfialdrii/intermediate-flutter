import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/api_state.dart';
import '../provider/api_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    final apiProvider = context.read<ApiProvider>();
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent) {
          if (apiProvider.pageItems != null) {
            apiProvider.getQuotes();
          }
        }
      },
    );
    Future.microtask(() async => apiProvider.getQuotes());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quote List App"),
      ),
      body: Consumer<ApiProvider>(
        builder: (context, value, child) {
          final state = value.quotesState;
          if (state == ApiState.loading && value.pageItems == 1) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state == ApiState.loaded) {
            final quotes = value.quotes;
            return ListView.builder(
              controller: scrollController,
              itemCount: quotes.length + (value.pageItems != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == quotes.length && value.pageItems != null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final quote = quotes[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quote.en,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(quote.author),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("No data"),
            );
          }
        },
      ),
    );
  }
}
