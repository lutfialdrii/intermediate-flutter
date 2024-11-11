import 'package:json_annotation/json_annotation.dart';
part 'general_response.g.dart';

@JsonSerializable()
class GeneralResponse {
  final bool? error;
  final String? message;

  GeneralResponse({
    this.error,
    this.message,
  });

  factory GeneralResponse.fromJson(Map<String, dynamic> json) =>
      _$GeneralResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralResponseToJson(this);
}
