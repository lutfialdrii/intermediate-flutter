import 'package:freezed_annotation/freezed_annotation.dart';
import 'quote.dart';

/// todo-03-03: import a dart file to insert generated file
part 'asset_response.g.dart';
part 'asset_response.freezed.dart';

/// todo-03-01: add this annotation to indicate Json Serializable class
@freezed
class AssetResponse with _$AssetResponse {
  const factory AssetResponse({
    @JsonKey(name: "list_quotes") required List<Quote> list,
  }) = _AssetResponse;

  factory AssetResponse.fromJson(json) => _$AssetResponseFromJson(json);
}
