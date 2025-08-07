import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import '../di/injection.dart';
import 'firebase_service.dart';

@lazySingleton
class LoggerService {
  late final Logger _logger;
  FirebaseService? _firebaseService;

  LoggerService() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
    );
    
    // Get Firebase service if available
    try {
      _firebaseService = getIt<FirebaseService>();
    } catch (e) {
      // Firebase service not available, continue without it
    }
  }

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    
    // Send error to Crashlytics
    if (error != null) {
      _firebaseService?.recordError(error, stackTrace, reason: message);
    } else {
      _firebaseService?.log('ERROR: $message');
    }
  }

  void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
    
    // Send fatal error to Crashlytics
    if (error != null) {
      _firebaseService?.recordError(error, stackTrace, reason: message, fatal: true);
    } else {
      _firebaseService?.log('FATAL: $message');
    }
  }
}
