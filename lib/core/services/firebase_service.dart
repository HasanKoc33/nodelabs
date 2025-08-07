import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirebaseService {
  late final FirebaseAnalytics _analytics;
  late final FirebaseCrashlytics _crashlytics;

  FirebaseService() {
    _analytics = FirebaseAnalytics.instance;
    _crashlytics = FirebaseCrashlytics.instance;
    _setupCrashlytics();
  }

  // Analytics getter
  FirebaseAnalytics get analytics => _analytics;

  // Crashlytics getter
  FirebaseCrashlytics get crashlytics => _crashlytics;

  void _setupCrashlytics() {
    // Enable crashlytics collection in release mode
    _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
    
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = _crashlytics.recordFlutterFatalError;
    
    // Pass all uncaught asynchronous errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Analytics Methods
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      debugPrint('Analytics log event error: $e');
    }
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      debugPrint('Analytics screen view error: $e');
    }
  }

  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      debugPrint('Analytics set user ID error: $e');
    }
  }

  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await _analytics.setUserProperty(
        name: name,
        value: value,
      );
    } catch (e) {
      debugPrint('Analytics set user property error: $e');
    }
  }

  // Crashlytics Methods
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    try {
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (e) {
      debugPrint('Crashlytics record error: $e');
    }
  }

  Future<void> log(String message) async {
    try {
      await _crashlytics.log(message);
    } catch (e) {
      debugPrint('Crashlytics log error: $e');
    }
  }

  Future<void> setCustomKey(String key, Object value) async {
    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (e) {
      debugPrint('Crashlytics set custom key error: $e');
    }
  }

  Future<void> setUserIdentifier(String identifier) async {
    try {
      await _crashlytics.setUserIdentifier(identifier);
    } catch (e) {
      debugPrint('Crashlytics set user identifier error: $e');
    }
  }

  // Convenience Methods
  Future<void> logLogin(String method) async {
    await logEvent(
      name: 'login',
      parameters: {'method': method},
    );
  }

  Future<void> logSignUp(String method) async {
    await logEvent(
      name: 'sign_up',
      parameters: {'method': method},
    );
  }

  Future<void> logMovieView(String movieId, String movieTitle) async {
    await logEvent(
      name: 'movie_view',
      parameters: {
        'movie_id': movieId,
        'movie_title': movieTitle,
      },
    );
  }

  Future<void> logMovieFavorite(String movieId, String movieTitle, bool isFavorite) async {
    await logEvent(
      name: 'movie_favorite',
      parameters: {
        'movie_id': movieId,
        'movie_title': movieTitle,
        'is_favorite': isFavorite,
      },
    );
  }

  Future<void> logSearch(String searchTerm) async {
    await logEvent(
      name: 'search',
      parameters: {'search_term': searchTerm},
    );
  }
}
