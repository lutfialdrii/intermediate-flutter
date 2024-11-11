import 'package:json_annotation/json_annotation.dart';
part 'get_all_stories_response.g.dart';

@JsonSerializable()
class GetAllStoriesResponse {
  final bool? error;
  final String? message;
  final List<Story>? listStory;

  GetAllStoriesResponse({
    this.error,
    this.message,
    this.listStory,
  });

  factory GetAllStoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllStoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllStoriesResponseToJson(this);
}

@JsonSerializable()
class Story {
  final String? id;
  final String? name;
  final String? description;
  final String? photoUrl;
  final DateTime? createdAt;
  final double? lat;
  final double? lon;

  Story({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
