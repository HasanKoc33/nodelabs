import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nodelabs/core/network/dio_client.dart';
import 'package:nodelabs/core/services/logger_service.dart';
import 'package:nodelabs/core/services/storage_service.dart';
import 'package:nodelabs/core/services/firebase_service.dart';
import 'package:nodelabs/data/datasources/remote/auth_remote_datasource.dart';
import 'package:nodelabs/data/datasources/remote/movie_remote_datasource.dart';
import 'package:nodelabs/data/datasources/local/auth_local_datasource.dart';
import 'package:nodelabs/data/repositories/auth_repository_impl.dart';
import 'package:nodelabs/data/repositories/movie_repository_impl.dart';
import 'package:nodelabs/core/network/network_info.dart';
import 'package:nodelabs/domain/repositories/auth_repository.dart';
import 'package:nodelabs/domain/repositories/movie_repository.dart';
import 'package:nodelabs/domain/usecases/usecase.dart';
import 'package:nodelabs/domain/usecases/auth/login_usecase.dart';
import 'package:nodelabs/domain/usecases/auth/register_usecase.dart';
import 'package:nodelabs/domain/usecases/auth/logout_usecase.dart';
import 'package:nodelabs/domain/usecases/auth/upload_photo_usecase.dart';
import 'package:nodelabs/domain/usecases/auth/refresh_profile_usecase.dart';
import 'package:nodelabs/domain/usecases/movie/get_movies_usecase.dart';
import 'package:nodelabs/domain/usecases/movie/add_to_favorites_usecase.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_bloc.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_event.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_state.dart';
// import 'package:nodelabs/presentation/bloc/movie/movie_bloc.dart'; // File doesn't exist
// import 'package:nodelabs/presentation/bloc/movie/movie_event.dart';
// import 'package:nodelabs/presentation/bloc/movie/movie_state.dart';

// Mocktail-based mocks for all core test classes
class MockAuthRepository extends Mock implements AuthRepository {}
class MockMovieRepository extends Mock implements MovieRepository {}
class MockLoggerService extends Mock implements LoggerService {}
class MockStorageService extends Mock implements StorageService {}
class MockFirebaseService extends Mock implements FirebaseService {
  @override
  Future<void> logLogin(String method) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> logSignUp(String method) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> setUserId(String userId) async {
    // Mock implementation - do nothing
  }
}
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}
class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

// UseCase mocks
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockUploadPhotoUseCase extends Mock implements UploadPhotoUseCase {}
class MockGetMoviesUseCase extends Mock implements GetMoviesUseCase {}
class MockAddToFavoritesUseCase extends Mock implements AddToFavoritesUseCase {}
class MockRefreshProfileUseCase extends Mock implements RefreshProfileUseCase {}
// Fake classes for bloc events/states (commented out until MovieEvent/MovieState exist)
// class FakeMovieEvent extends Fake implements MovieEvent {}
// class FakeMovieState extends Fake implements MovieState {}

// Bloc mocks
class MockAuthBloc extends Mock implements AuthBloc {}
// class MockMovieBloc extends Mock implements MovieBloc {} // MovieBloc doesn't exist

// Remove mockito annotation and use only mocktail-based mocks
// @GenerateMocks([
  // Core

void main() {
  // Register fallback values for mocktail
  registerFallbackValue(LoginParams(email: '', password: ''));
  registerFallbackValue(RegisterParams(name: '', email: '', password: ''));
  registerFallbackValue(NoParams());
  registerFallbackValue(GetMoviesParams(page: 1));
  registerFallbackValue(AddToFavoritesParams(movieId: ''));
  // registerFallbackValue<MovieEvent>(FakeMovieEvent());
  // registerFallbackValue<MovieState>(FakeMovieState());
}


// Test Utilities
class TestUtils {
  /// Creates a MaterialApp wrapper for widget testing
  static Widget createTestApp(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }
  
  /// Creates a MaterialApp with theme for widget testing
  static Widget createTestAppWithTheme(Widget child, {ThemeData? theme}) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }
  
  /// Pumps widget and settles all animations
  static Future<void> pumpAndSettleWidget(
    WidgetTester tester,
    Widget widget, {
    Duration? duration,
  }) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle(duration ?? const Duration(milliseconds: 100));
  }
  
  /// Common test timeout duration
  static const Duration testTimeout = Duration(seconds: 30);
  
  /// Common pump duration for animations
  static const Duration pumpDuration = Duration(milliseconds: 100);
}
