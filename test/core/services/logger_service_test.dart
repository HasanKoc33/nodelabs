import 'package:flutter_test/flutter_test.dart';
import 'package:nodelabs/core/services/logger_service.dart';

void main() {
  group('LoggerService', () {
    late LoggerService loggerService;

    setUp(() {
      loggerService = LoggerService();
    });

    test('should create LoggerService instance', () {
      // Assert
      expect(loggerService, isA<LoggerService>());
    });

    group('Logging methods', () {
      test('should call debug method without throwing', () {
        // Act & Assert
        expect(
          () => loggerService.debug('Debug message'),
          returnsNormally,
        );
      });

      test('should call debug method with error and stackTrace', () {
        // Arrange
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;

        // Act & Assert
        expect(
          () => loggerService.debug('Debug message', error, stackTrace),
          returnsNormally,
        );
      });

      test('should call info method without throwing', () {
        // Act & Assert
        expect(
          () => loggerService.info('Info message'),
          returnsNormally,
        );
      });

      test('should call info method with error and stackTrace', () {
        // Arrange
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;

        // Act & Assert
        expect(
          () => loggerService.info('Info message', error, stackTrace),
          returnsNormally,
        );
      });

      test('should call warning method without throwing', () {
        // Act & Assert
        expect(
          () => loggerService.warning('Warning message'),
          returnsNormally,
        );
      });

      test('should call warning method with error and stackTrace', () {
        // Arrange
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;

        // Act & Assert
        expect(
          () => loggerService.warning('Warning message', error, stackTrace),
          returnsNormally,
        );
      });

      test('should call error method without throwing', () {
        // Act & Assert
        expect(
          () => loggerService.error('Error message'),
          returnsNormally,
        );
      });

      test('should call error method with error and stackTrace', () {
        // Arrange
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;

        // Act & Assert
        expect(
          () => loggerService.error('Error message', error, stackTrace),
          returnsNormally,
        );
      });

      test('should call fatal method without throwing', () {
        // Act & Assert
        expect(
          () => loggerService.fatal('Fatal message'),
          returnsNormally,
        );
      });

      test('should call fatal method with error and stackTrace', () {
        // Arrange
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;

        // Act & Assert
        expect(
          () => loggerService.fatal('Fatal message', error, stackTrace),
          returnsNormally,
        );
      });
    });

    group('Edge cases', () {
      test('should handle null error gracefully', () {
        // Act & Assert
        expect(
          () => loggerService.error('Error message', null, null),
          returnsNormally,
        );
      });

      test('should handle empty message', () {
        // Act & Assert
        expect(
          () => loggerService.info(''),
          returnsNormally,
        );
      });

      test('should handle very long message', () {
        // Arrange
        final longMessage = 'A' * 1000;

        // Act & Assert
        expect(
          () => loggerService.info(longMessage),
          returnsNormally,
        );
      });

      test('should handle special characters in message', () {
        // Arrange
        const specialMessage = 'Message with special chars: 🚀 ñáéíóú @#\$%^&*()';

        // Act & Assert
        expect(
          () => loggerService.info(specialMessage),
          returnsNormally,
        );
      });
    });
  });
}
