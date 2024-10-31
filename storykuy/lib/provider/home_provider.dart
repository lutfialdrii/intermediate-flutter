// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:storykuy/data/model/get_all_stories_response.dart';
import 'package:storykuy/data/repository/story_repository.dart';
import '../common/result_state.dart';

class HomeProvider extends ChangeNotifier {
  final StoryRepository storyRepository;

  ResultState _state = ResultState.initial;
  ResultState get state => _state;

  List<Story>? _stories;
  List<Story> get stories => _stories ?? [];

  String _message = "";
  String get message => _message;
  HomeProvider(
    this.storyRepository,
  ) {
    fetchStories();
  }

  Future<void> fetchStories() async {
    _state = ResultState.loading;
    notifyListeners();

    final response = await storyRepository.fetchStories();
    if (response.listStory!.isNotEmpty && !response.error!) {
      _stories = response.listStory;
      _state = ResultState.loaded;
      notifyListeners();
    } else if (response.error! && response.message != null) {
      _message = response.message!;
      _state = ResultState.error;
      notifyListeners();
    } else {
      _state = ResultState.error;
      notifyListeners();
      _message = "Gagal terhubung dengan server!";
    }
  }
}
