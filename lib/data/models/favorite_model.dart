import 'package:json_annotation/json_annotation.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteResponse {
  final FavoriteData data;

  const FavoriteResponse({
    required this.data,
  });

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) =>
      _$FavoriteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteResponseToJson(this);
}

@JsonSerializable()
class FavoriteData {
  final String action;
  final Map<String, dynamic> movie;

  const FavoriteData({
    required this.action,
    required this.movie,
  });

  factory FavoriteData.fromJson(Map<String, dynamic> json) =>
      _$FavoriteDataFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteDataToJson(this);
}
