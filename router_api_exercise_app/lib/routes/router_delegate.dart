import 'package:declarative_navigation/screen/form_screen.dart';
import 'package:flutter/material.dart';

import '../model/quote.dart';
import '../screen/quote_detail_screen.dart';
import '../screen/quotes_list_screen.dart';

/// todo 1: create new class router-delegate
class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  /// todo 2: add navigator key,
  /// change other method, and
  /// add the variable to Navigator widget
  final GlobalKey<NavigatorState> _navigatorKey;
  bool isForm = false;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// todo 3: move Navigator widget to build method,
  /// add selected quote variable,
  /// delete setState function, and
  /// change with notifiyListener().
  String? selectedQuote;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey("QuotesListScreen"),
          child: QuotesListScreen(
            quotes: quotes,
            onTapped: (String quoteId) {
              selectedQuote = quoteId;
              notifyListeners();
            },
            toFormScreen: () {
              isForm = true;
              notifyListeners();
            },
          ),
        ),
        if (selectedQuote != null)
          MaterialPage(
            key: ValueKey(selectedQuote),
            child: QuoteDetailsScreen(
              quoteId: selectedQuote!,
            ),
          ),
        if (isForm)
          MaterialPage(
            key: ValueKey('FormScreen'),
            child: FormScreen(
              onSend: () {
                isForm = false;
                notifyListeners();
              },
            ),
          )
      ],
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        selectedQuote = null;
        isForm = false;
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
