// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteResponse _$FavoriteResponseFromJson(Map<String, dynamic> json) =>
    FavoriteResponse(
      data: FavoriteData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavoriteResponseToJson(FavoriteResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

FavoriteData _$FavoriteDataFromJson(Map<String, dynamic> json) => FavoriteData(
      action: json['action'] as String,
      movie: json['movie'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$FavoriteDataToJson(FavoriteData instance) =>
    <String, dynamic>{
      'action': instance.action,
      'movie': instance.movie,
    };
