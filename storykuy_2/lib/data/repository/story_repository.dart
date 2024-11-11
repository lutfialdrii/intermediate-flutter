import 'package:storykuy/data/model/general_response.dart';
import 'package:storykuy/data/model/get_all_stories_response.dart';
import '../dio/dio_service.dart';

class StoryRepository {
  final DioService dioService;

  StoryRepository({required this.dioService});

  Future<GetAllStoriesResponse> fetchStories([int page = 1, int size = 10]) async {
    try {
      final response = await dioService.fetchAllStories(page, size);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse> uploadStory(
    List<int> bytes,
    String fileName,
    String description,
  ) async {
    try {
      final response =
          await dioService.uploadStory(bytes, fileName, description);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse> uploadStoryWithLocation(
    List<int> bytes,
    String fileName,
    String description,
    String lat,
    String lon,
  ) async {
    try {
      final response = await dioService.uploadStoryWithLocation(
        bytes,
        fileName,
        description,
        lat,
        lon,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
