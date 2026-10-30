import 'package:json_annotation/json_annotation.dart';
import 'package:base_flutter_ai/core/utils/safe_parser.dart';
import 'package:base_flutter_ai/features/home/domain/entities/post_entity.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  @JsonKey(readValue: _readId)
  final int id;

  @JsonKey(name: 'userId', readValue: _readUserId)
  final int userId;

  @JsonKey(defaultValue: '')
  final String title;

  @JsonKey(defaultValue: '')
  final String body;

  @JsonKey(readValue: _readViews)
  final int views;

  @JsonKey(readValue: _readRating)
  final double rating;

  const PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.views = 0,
    this.rating = 0.0,
  });

  // Safe readers using SafeParser to handle nulls and mixed string/numeric values from APIs
  static Object? _readId(Map<dynamic, dynamic> json, String key) =>
      SafeParser.toInt(json[key]);

  static Object? _readUserId(Map<dynamic, dynamic> json, String key) =>
      SafeParser.toInt(json[key]);

  static Object? _readViews(Map<dynamic, dynamic> json, String key) =>
      SafeParser.toInt(json[key]);

  static Object? _readRating(Map<dynamic, dynamic> json, String key) =>
      SafeParser.toDouble(json[key]);

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      userId: userId,
      title: title,
      body: body,
      views: views,
      rating: rating,
    );
  }

  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      body: entity.body,
      views: entity.views,
      rating: entity.rating,
    );
  }
}
