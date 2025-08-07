import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/services/storage_service.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();
  Future<bool> isLoggedIn();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService _storageService;

  AuthLocalDataSourceImpl(this._storageService);

  @override
  Future<void> saveToken(String token) async {
    try {
      await _storageService.setSecureString(AppConstants.tokenKey, token);
    } catch (e) {
      throw CacheException('Failed to save token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _storageService.getSecureString(AppConstants.tokenKey);
    } catch (e) {
      throw CacheException('Failed to get token: $e');
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _storageService.deleteSecureString(AppConstants.tokenKey);
    } catch (e) {
      throw CacheException('Failed to delete token: $e');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _storageService.setString(AppConstants.userKey, userJson);
    } catch (e) {
      throw CacheException('Failed to save user: $e');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final userJson = _storageService.getString(AppConstants.userKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get user: $e');
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await _storageService.remove(AppConstants.userKey);
    } catch (e) {
      throw CacheException('Failed to delete user: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
