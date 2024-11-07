import 'package:storykuy/data/model/general_response.dart';
import 'package:storykuy/data/model/get_all_stories_response.dart';
import '../dio/dio_service.dart';

class StoryRepository {
  final DioService dioService;

  StoryRepository({required this.dioService});

  Future<GetAllStoriesResponse> fetchStories() async {
    try {
      final response = await dioService.fetchAllStories();
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
}
