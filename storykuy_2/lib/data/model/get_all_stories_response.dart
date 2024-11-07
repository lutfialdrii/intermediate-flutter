// To parse this JSON data, do
//
//     final getAllStoriesResponse = getAllStoriesResponseFromJson(jsonString);

import 'dart:convert';

GetAllStoriesResponse getAllStoriesResponseFromJson(String str) =>
    GetAllStoriesResponse.fromJson(json.decode(str));

String getAllStoriesResponseToJson(GetAllStoriesResponse data) =>
    json.encode(data.toJson());

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
      GetAllStoriesResponse(
        error: json["error"],
        message: json["message"],
        listStory: json["listStory"] == null
            ? []
            : List<Story>.from(
                json["listStory"]!.map((x) => Story.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "listStory": listStory == null
            ? []
            : List<dynamic>.from(listStory!.map((x) => x.toJson())),
      };
}

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

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "createdAt": createdAt?.toIso8601String(),
        "lat": lat,
        "lon": lon,
      };
}
