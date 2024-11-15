import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redirection_exercise/main.dart';
import 'package:redirection_exercise/provider/auth_provider.dart';

import '../model/quote.dart';

class QuotesListScreen extends StatelessWidget {
  final List<Quote> quotes;
  final Function(String) onTapped;
  final Function() onLogout;

  const QuotesListScreen({
    Key? key,
    required this.quotes,
    required this.onTapped,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes App"),
      ),
      body: ListView(
        children: [
          for (var quote in quotes)
            ListTile(
              title: Text(quote.author),
              subtitle: Text(quote.quote),
              isThreeLine: true,
              onTap: () => onTapped(quote.id),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final authRead = context.read<AuthProvider>();
          final result = await authRead.logout();
          if (result) onLogout();
        },
        tooltip: "Logout",
        child: authWatch.isLoadingLogout
            ? CircularProgressIndicator()
            : Icon(Icons.logout),
      ),
    );
  }
}
