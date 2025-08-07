import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/auth_model.dart';
import '../../models/user_model.dart';

part 'auth_remote_datasource.g.dart';

@RestApi()
@injectable
abstract class AuthRemoteDataSource {
  @factoryMethod
  factory AuthRemoteDataSource(Dio dio) = _AuthRemoteDataSource;

  @POST('/user/login')
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST('/user/register')
  Future<AuthResponse> register(@Body() RegisterRequest request);

  @POST('/user/logout')
  Future<void> logout();

  @GET('/user/profile')
  Future<UserModel> getCurrentUser();

  @POST('/user/refresh')
  Future<AuthResponse> refreshToken(@Body() Map<String, String> refreshToken);

  @POST('/user/upload_photo')
  @MultiPart()
  Future<UploadPhotoResponse> uploadPhoto(@Part() File file);
}
