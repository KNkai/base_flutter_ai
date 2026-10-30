// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
  id: (PostModel._readId(json, 'id') as num).toInt(),
  userId: (PostModel._readUserId(json, 'userId') as num).toInt(),
  title: json['title'] as String? ?? '',
  body: json['body'] as String? ?? '',
  views: (PostModel._readViews(json, 'views') as num?)?.toInt() ?? 0,
  rating: (PostModel._readRating(json, 'rating') as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'body': instance.body,
  'views': instance.views,
  'rating': instance.rating,
};
