import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  final String name;
  final String email;
  final String password;

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class AuthResponse {
  final String token;
  final UserModel user;

  const AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AuthResponse(
      token: data['token'] as String,
      user: UserModel.fromJson(data),
    );
  }
  
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class UploadPhotoResponse {
  final String photoUrl;

  const UploadPhotoResponse({
    required this.photoUrl,
  });

  factory UploadPhotoResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadPhotoResponseFromJson(json['data'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$UploadPhotoResponseToJson(this);
}
