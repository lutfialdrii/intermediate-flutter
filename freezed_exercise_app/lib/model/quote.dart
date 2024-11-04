import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

/// todo-02-03: import a dart file to insert generated file
part 'quote.g.dart';
part 'quote.freezed.dart';

/// todo-02-01: add this annotation to indicate Json Serializable class
@freezed
class Quote with _$Quote {
  const factory Quote({
    required String id,
    required String en,
    required String author,
    required String rating,
  }) = _Quote;

  /// todo-02-02: change the [fromJson] and [toJson] methods into this code
  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
}
