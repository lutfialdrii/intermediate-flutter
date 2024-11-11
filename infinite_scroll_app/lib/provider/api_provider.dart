import 'package:flutter/material.dart';
import '../model/quote.dart';
import '../service/api_service.dart';

import '../model/api_state.dart';

class ApiProvider extends ChangeNotifier {
  final ApiService apiService;

  ApiProvider(this.apiService);

  ApiState quotesState = ApiState.initial;
  String quotesMessage = "";

  bool quotesError = false;

  List<Quote> quotes = [];

  int? pageItems = 1;
  int sizeItems = 10;

  Future<void> getQuotes() async {
    try {
      if (pageItems == 1) {
        quotesState = ApiState.loading;
        notifyListeners();
      }

      final result = await apiService.getQuotes(pageItems!, sizeItems);

      quotes.addAll(result.list);
      quotesMessage = "Success";
      quotesError = false;
      quotesState = ApiState.loaded;

      if (result.list.length < sizeItems) {
        pageItems = null;
      } else {
        pageItems = pageItems! + 1;
      }
      notifyListeners();
    } catch (e) {
      quotesState = ApiState.error;
      quotesError = true;
      quotesMessage = "Get quotes failed";
      notifyListeners();
    }
  }
}
