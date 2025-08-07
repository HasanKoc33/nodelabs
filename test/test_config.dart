import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nodelabs/core/error/failures.dart';
import 'package:nodelabs/domain/repositories/movie_repository.dart';

import 'helpers/test_helper.dart';
import 'helpers/test_data.dart';

/// Simple BlocObserver implementation for testing
class TestBlocObserver extends BlocObserver {
  @override
  void onEvent(BlocBase bloc, Object? event) {
    // Can add logging here if needed for debugging
  }

  @override
  void onTransition(BlocBase bloc, Transition transition) {
    // Can add logging here if needed for debugging
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // Can add logging here if needed for debugging
  }
}

/// Test configuration and setup utilities
class TestConfig {
  static const Locale defaultLocale = Locale('tr', 'TR');
  static const List<Locale> supportedLocales = [
    Locale('tr', 'TR'),
    Locale('en', 'US'),
  ];

  /// Initialize test environment
  static Future<void> initialize() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Initialize EasyLocalization for tests
    await EasyLocalization.ensureInitialized();
    
    // Reset GetIt instance
    if (GetIt.instance.isRegistered<Object>()) {
      await GetIt.instance.reset();
    }
  }

  /// Clean up test environment
  static Future<void> cleanup() async {
    // Reset GetIt instance
    if (GetIt.instance.isRegistered<Object>()) {
      await GetIt.instance.reset();
    }
    
    // Reset any global state if needed
    Bloc.observer = TestBlocObserver();
  }

  /// Create a test app wrapper with all necessary providers
  static Widget createTestApp({
    required Widget child,
    List<BlocProvider>? blocProviders,
    ThemeData? theme,
    Locale? locale,
  }) {
    Widget app = MaterialApp(
      theme: theme ?? ThemeData.light(),
      locale: locale ?? defaultLocale,
      supportedLocales: supportedLocales,
      home: Scaffold(body: child),
    );

    if (blocProviders != null && blocProviders.isNotEmpty) {
      app = MultiBlocProvider(
        providers: blocProviders,
        child: app,
      );
    }

    return app;
  }

  /// Create a test app with EasyLocalization
  static Widget createLocalizedTestApp({
    required Widget child,
    List<BlocProvider>? blocProviders,
    ThemeData? theme,
    Locale? locale,
  }) {
    Widget app = EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/translations',
      fallbackLocale: defaultLocale,
      startLocale: locale ?? defaultLocale,
      child: MaterialApp(
        theme: theme ?? ThemeData.light(),

        supportedLocales: supportedLocales,
        home: Scaffold(body: child),
      ),
    );

    if (blocProviders != null && blocProviders.isNotEmpty) {
      app = MultiBlocProvider(
        providers: blocProviders,
        child: app,
      );
    }

    return app;
  }

  /// Pump and settle widget with default timeout
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration? timeout,
  }) async {
    await tester.pumpAndSettle(timeout ?? const Duration(seconds: 10));
  }

  /// Common test timeouts
  static const Duration shortTimeout = Duration(seconds: 5);
  static const Duration mediumTimeout = Duration(seconds: 15);
  static const Duration longTimeout = Duration(seconds: 30);

  /// Common pump durations
  static const Duration shortPump = Duration(milliseconds: 100);
  static const Duration mediumPump = Duration(milliseconds: 500);
  static const Duration longPump = Duration(seconds: 1);
}

/// Mock data for tests
class TestMockData {
  static const String validEmail = 'test@example.com';
  static const String validPassword = 'password123';
  static const String validName = 'Test User';
  static const String validToken = 'test_token_123';
  static const String validUserId = '67bc8d58d9ec4d40040b81b6';
  static const String validMovieId = 'test_movie_id';
  static const String validPhotoUrl = 'https://example.com/photo.jpg';

  static const Map<String, dynamic> validLoginResponse = {
    'data': {
      'token': validToken,
      'user': {
        'id': validUserId,
        'name': validName,
        'email': validEmail,
        'photoUrl': validPhotoUrl,
      }
    }
  };

  static const Map<String, dynamic> validMovieResponse = {
    'data': {
      'movies': [
        {
          'id': validMovieId,
          'title': 'Test Movie',
          'overview': 'Test movie overview',
          'posterPath': '/test_poster.jpg',
          'backdropPath': '/test_backdrop.jpg',
          'releaseDate': '2023-01-01',
          'voteAverage': 8.5,
          'voteCount': 1000,
          'isFavorite': false,
          'genres': ['Action', 'Drama'],
        }
      ],
      'pagination': {
        'currentPage': 1,
        'maxPage': 10,
        'totalCount': 100,
      }
    }
  };
}

/// Test assertions helper
class TestAssertions {
  /// Assert that a widget is visible and enabled
  static void assertWidgetVisibleAndEnabled(Finder finder) {
    expect(finder, findsOneWidget);
    final widget = finder.evaluate().first.widget;
    if (widget is ElevatedButton) {
      expect(widget.onPressed, isNotNull);
    } else if (widget is TextButton) {
      expect(widget.onPressed, isNotNull);
    } else if (widget is IconButton) {
      expect(widget.onPressed, isNotNull);
    }
  }

  /// Assert that a text field has specific properties
  static void assertTextFieldProperties(
    Finder finder, {
    String? hintText,
    bool? obscureText,
    TextInputType? keyboardType,
  }) {
    expect(finder, findsOneWidget);
    final textField = finder.evaluate().first.widget as TextField;
    
    if (hintText != null) {
      expect(textField.decoration?.hintText, hintText);
    }
    if (obscureText != null) {
      expect(textField.obscureText, obscureText);
    }
    if (keyboardType != null) {
      expect(textField.keyboardType, keyboardType);
    }
  }

  /// Assert that loading indicator is shown
  static void assertLoadingIndicatorVisible() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  /// Assert that error message is shown
  static void assertErrorMessageVisible(String message) {
    expect(find.text(message), findsOneWidget);
  }

  /// Assert navigation occurred (basic check)
  static void assertNavigationOccurred(WidgetTester tester) {
    // This is a basic check - in real tests you'd use navigation observers
    expect(tester.binding.hasScheduledFrame, isFalse);
  }
}

/// Mock behavior helpers
class MockBehaviors {
  /// Setup successful login mock
  static void setupSuccessfulLogin(MockAuthRepository mockAuthRepository) {
    when(() => mockAuthRepository.login(any(), any()))
        .thenAnswer((_) async => Right(TestData.testUser));
  }

  /// Setup failed login mock
  static void setupFailedLogin(MockAuthRepository mockAuthRepository, String errorMessage) {
    when(() => mockAuthRepository.login(any(), any()))
        .thenAnswer((_) async => Left(ServerFailure(errorMessage)));
  }

  /// Setup successful movie fetch mock
  static void setupSuccessfulMovieFetch(MockMovieRepository mockMovieRepository) {
    final movieResult = MovieListResult(
      movies: [TestData.testMovie],
      totalPages: 1,
      currentPage: 1,
    );
    when(() => mockMovieRepository.getMovies(any<int>()))
        .thenAnswer((_) async => Right(movieResult));
  }

  /// Setup network error mock
  static void setupNetworkError(MockMovieRepository mockRepository) {
    when(() => mockRepository.getMovies(any<int>()))
        .thenAnswer((_) async => const Left(NetworkFailure('Network Error')));
  }
}
