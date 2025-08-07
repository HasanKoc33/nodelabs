import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  @JsonKey(name: 'photoUrl')
  final String? photoUrl;

  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    this.photoUrl,
    super.favoriteMovies,
  }) : super(profileImageUrl: photoUrl);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle both direct user data and wrapped response
    final userData = json.containsKey('data') ? json['data'] as Map<String, dynamic> : json;
    return _$UserModelFromJson(userData);
  }
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      photoUrl: user.profileImageUrl,
      favoriteMovies: user.favoriteMovies,
    );
  }
}
