import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:nodelabs/core/error/exceptions.dart';
import 'package:nodelabs/core/error/failures.dart';
import 'package:nodelabs/core/network/network_info.dart';
import 'package:nodelabs/data/datasources/local/auth_local_datasource.dart';
import 'package:nodelabs/data/datasources/remote/auth_remote_datasource.dart';
import 'package:nodelabs/data/models/auth_model.dart';
import 'package:nodelabs/domain/entities/user.dart';
import 'package:nodelabs/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository] that handles authentication operations
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  /// Creates an instance of [AuthRepositoryImpl].
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final request = LoginRequest(email: email, password: password);
        final response = await remoteDataSource.login(request);
        
        // Save token and user data locally
        await localDataSource.saveToken(response.token);
        await localDataSource.saveUser(response.user);
        
        return Right(response.user);
      } on DioException catch (e) {
        String errorMessage = _extractErrorMessage(e);
        if (e.response?.statusCode == 401) {
          return Left(AuthFailure(errorMessage));
        } else {
          return Left(ServerFailure(errorMessage));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error occurred: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> register(String name, String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final request = RegisterRequest(name: name, email: email, password: password);
        final response = await remoteDataSource.register(request);
        
        // Save token and user data locally
        await localDataSource.saveToken(response.token);
        await localDataSource.saveUser(response.user);
        
        return Right(response.user);
      } on DioException catch (e) {
        String errorMessage = _extractErrorMessage(e);
        if (e.response?.statusCode == 401) {
          return Left(AuthFailure(errorMessage));
        } else {
          return Left(ServerFailure(errorMessage));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error occurred: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Try to logout from server if connected
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.logout();
        } catch (e) {
          // Continue with local logout even if server logout fails
        }
      }
      
      // Clear local data
      await localDataSource.deleteToken();
      await localDataSource.deleteUser();
      
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('errors.logoutFailed'.tr()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('errors.getCurrentUserFailed'.tr()));
    }
  }

  @override
  Future<Either<Failure, User>> refreshProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getCurrentUser();
        // Update local cache with fresh data
        await localDataSource.saveUser(user);
        return Right(user);
      } on DioException catch (e) {
        String errorMessage = _extractErrorMessage(e);
        if (e.response?.statusCode == 401) {
          return Left(AuthFailure(errorMessage));
        } else {
          return Left(ServerFailure(errorMessage));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('errors.refreshProfileFailed'.tr()));
      }
    } else {
      return Left(NetworkFailure('errors.noInternetConnection'.tr()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isLoggedIn();
      return Right(isLoggedIn);
    } catch (e) {
      return Left(CacheFailure('errors.checkLoginStatusFailed'.tr()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    if (await networkInfo.isConnected) {
      try {
        final currentToken = await localDataSource.getToken();
        if (currentToken != null) {
          final response = await remoteDataSource.refreshToken({'refresh_token': currentToken});
          await localDataSource.saveToken(response.token);
          return const Right(null);
        } else {
          return Left(AuthFailure('errors.noTokenToRefresh'.tr()));
        }
      } on DioException catch (e) {
        String errorMessage = _extractErrorMessage(e);
        if (e.response?.statusCode == 401) {
          return Left(AuthFailure(errorMessage));
        } else {
          return Left(ServerFailure(errorMessage));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('errors.refreshTokenFailed'.tr()));
      }
    } else {
      return Left(NetworkFailure('errors.noInternetConnection'.tr()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(File file) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.uploadPhoto(file);
        return Right(response.photoUrl);
      } on DioException catch (e) {
        String errorMessage = _extractErrorMessage(e);
        if (e.response?.statusCode == 401) {
          return Left(AuthFailure(errorMessage));
        } else {
          return Left(ServerFailure(errorMessage));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('errors.uploadPhotoFailed'.tr()));
      }
    } else {
      return Left(NetworkFailure('errors.noInternetConnection'.tr()));
    }
  }

  /// Extracts error message from DioException response
  String _extractErrorMessage(DioException e) {
    try {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          final error = data['response']['message'] as String?;
          return 'errors.${(error ??
              'serverError')}'.tr();
        } else if (data is String) {
          return data;
        }
      }
      
      // Fallback to DioException message
      return e.message ?? 'errors.networkError'.tr();
    } catch (_) {
      return 'errors.requestProcessingError'.tr();
    }
  }
}
