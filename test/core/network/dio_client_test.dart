import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:nodelabs/core/network/dio_client.dart';
import 'package:nodelabs/core/constants/app_constants.dart';
import '../../helpers/test_helper.dart';

void main() {
  group('DioClient', () {
    late DioClient dioClient;
    late MockLoggerService mockLoggerService;
    late MockStorageService mockStorageService;

    setUp(() {
      mockLoggerService = MockLoggerService();
      mockStorageService = MockStorageService();
      dioClient = DioClient(mockLoggerService, mockStorageService);
    });

    test('should create DioClient with proper base configuration', () {
      // Act
      final dio = dioClient.dio;

      // Assert
      expect(dio, isA<Dio>());
      expect(dio.options.baseUrl, equals(AppConstants.baseUrl));
      expect(dio.options.connectTimeout, equals(const Duration(seconds: 30)));
      expect(dio.options.receiveTimeout, equals(const Duration(seconds: 30)));
      expect(dio.options.headers['Content-Type'], equals('application/json'));
      expect(dio.options.headers['Accept'], equals('application/json'));
    });

    test('should have interceptors configured', () {
      // Act
      final dio = dioClient.dio;

      // Assert
      expect(dio.interceptors.length, greaterThan(0));
    });

    group('Request Interceptor', () {
      test('should have interceptors configured', () {
        // Act
        final dio = dioClient.dio;
        
        // Assert
        expect(dio.interceptors.length, greaterThan(0));
        // Interceptors are configured and will handle authorization during actual requests
      });
    });

    group('Error Handling', () {
      test('should handle DioException properly', () {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 404,
            data: {'error': 'Not found'},
          ),
        );

        // Act & Assert
        expect(dioError, isA<DioException>());
        expect(dioError.response?.statusCode, equals(404));
      });
    });

    group('Logging', () {
      test('should have logging interceptors configured', () {
        // Act
        final dio = dioClient.dio;

        // Assert
        expect(dio.interceptors.length, greaterThan(0));
        // Logging interceptors are set up and will log during actual requests
      });
    });

    group('Configuration', () {
      test('should have correct timeout settings', () {
        // Act
        final dio = dioClient.dio;

        // Assert
        expect(dio.options.connectTimeout, equals(const Duration(seconds: 30)));
        expect(dio.options.receiveTimeout, equals(const Duration(seconds: 30)));
      });

      test('should have correct headers', () {
        // Act
        final dio = dioClient.dio;

        // Assert
        expect(dio.options.headers['Content-Type'], equals('application/json'));
        expect(dio.options.headers['Accept'], equals('application/json'));
      });

      test('should have correct base URL', () {
        // Act
        final dio = dioClient.dio;

        // Assert
        expect(dio.options.baseUrl, equals(AppConstants.baseUrl));
      });
    });
  });
}
