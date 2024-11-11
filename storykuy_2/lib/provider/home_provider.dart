// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storykuy/data/model/general_response.dart';
import 'package:storykuy/data/model/get_all_stories_response.dart';
import 'package:storykuy/data/repository/story_repository.dart';
import '../common/result_state.dart';
import 'package:image/image.dart' as img;

class HomeProvider extends ChangeNotifier {
  String? imagePath;

  XFile? imageFile;

  final StoryRepository storyRepository;

  ResultState _state = ResultState.initial;
  ResultState get state => _state;

  ResultState _uploadState = ResultState.initial;
  ResultState get uploadState => _uploadState;

  List<Story> stories = [];

  GeneralResponse? _uploadResponse;
  GeneralResponse? get uploadResponse => _uploadResponse;

  String _message = "";
  String get message => _message;

  int? pageItems = 1;
  int sizeItems = 10;

  HomeProvider(
    this.storyRepository,
  );

  Future<void> fetchStories({refresh = false}) async {
    try {
      if (refresh) {
        pageItems = 1;
        stories = [];
      }
      if (pageItems == 1) {
        _state = ResultState.loading;
        notifyListeners();
      }

      final response =
          await storyRepository.fetchStories(pageItems!, sizeItems);
      if (response.listStory!.isNotEmpty && !response.error!) {
        // _stories = response.listStory;
        stories.addAll(response.listStory!);
        _state = ResultState.loaded;
        pageItems = pageItems! + 1;

        if (response.listStory!.length < sizeItems) {
          pageItems = null;
        } else {
          pageItems = pageItems! + 1;
        }
        notifyListeners();
      } else if (response.error! && response.message != null) {
        _message = response.message!;
        _state = ResultState.error;
        notifyListeners();
      } else {
        _state = ResultState.error;
        notifyListeners();
        _message = "Failed to connect server!";
      }
    } catch (e) {
      _message = e.toString();
      _state = ResultState.error;
      notifyListeners();
    }
  }

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  compressImage(Uint8List bytes) {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;
    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];
    do {
      compressQuality -= 10;
      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );
      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }

  Future<void> upload(
      List<int> bytes, String fileName, String description) async {
    _message = "";
    _uploadResponse = null;
    _uploadState = ResultState.loading;
    notifyListeners();
    try {
      final response =
          await storyRepository.uploadStory(bytes, fileName, description);
      if (!response.error!) {
        _uploadState = ResultState.loaded;
        _uploadResponse = uploadResponse;
        _message = response.message!;
      } else {
        _uploadState = ResultState.error;
        _message = response.message ?? "Something went wrong!!";
      }
    } catch (e) {
      _uploadState = ResultState.error;
      _message = e.toString();
    }
    notifyListeners();
  }

  Future<void> uploadWithLocation(
    List<int> bytes,
    String fileName,
    String description,
    String latitude,
    String longitude,
  ) async {
    _message = "";
    _uploadResponse = null;
    _uploadState = ResultState.loading;
    notifyListeners();
    try {
      final response = await storyRepository.uploadStoryWithLocation(
        bytes,
        fileName,
        description,
        latitude,
        longitude,
      );
      if (!response.error!) {
        _uploadState = ResultState.loaded;
        _uploadResponse = uploadResponse;
        _message = response.message!;
      } else {
        _uploadState = ResultState.error;
        _message = response.message ?? "Something went wrong!!";
      }
    } catch (e) {
      _uploadState = ResultState.error;
      _message = e.toString();
    }
    notifyListeners();
  }
}
