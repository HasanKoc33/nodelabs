import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:nodelabs/data/datasources/remote/auth_remote_datasource.dart';
import 'package:nodelabs/data/models/auth_model.dart';
import 'package:nodelabs/data/models/user_model.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  group('AuthRemoteDataSource', () {
    late AuthRemoteDataSource dataSource;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      dataSource = AuthRemoteDataSource(mockDio);
    });

    group('login', () {
      test('should perform POST request to /user/login and return AuthResponse', () async {
        // Arrange
        final responseData = TestData.testAuthResponseJson;
        when(mockDio.post(
          '/user/login',
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/user/login'),
        ));

        // Act
        final result = await dataSource.login(TestData.testLoginRequest);

        // Assert
        expect(result, isA<AuthResponse>());
        expect(result.token, equals('test_token_123'));
        expect(result.user.email, equals('test@example.com'));
        
        verify(mockDio.post(
          '/user/login',
          data: TestData.testLoginRequest.toJson(),
        )).called(1);
      });

      test('should throw DioException when login fails', () async {
        // Arrange
        when(mockDio.post(
          '/user/login',
          data: anyNamed('data'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/user/login'),
          response: Response(
            statusCode: 401,
            statusMessage: 'Unauthorized',
            requestOptions: RequestOptions(path: '/user/login'),
            data: {'error': 'Invalid credentials'},
          ),
        ));

        // Act & Assert
        expect(
          () => dataSource.login(TestData.testLoginRequest),
          throwsA(isA<DioException>()),
        );
        
        verify(mockDio.post(
          '/user/login',
          data: TestData.testLoginRequest.toJson(),
        )).called(1);
      });

      test('should handle network errors', () async {
        // Arrange
        when(mockDio.post(
          '/user/login',
          data: anyNamed('data'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/user/login'),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        ));

        // Act & Assert
        expect(
          () => dataSource.login(TestData.testLoginRequest),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('register', () {
      test('should perform POST request to /user/register and return AuthResponse', () async {
        // Arrange
        final responseData = TestData.testAuthResponseJson;
        when(mockDio.post(
          '/user/register',
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: '/user/register'),
        ));

        // Act
        final result = await dataSource.register(TestData.testRegisterRequest);

        // Assert
        expect(result, isA<AuthResponse>());
        expect(result.token, equals('test_token_123'));
        expect(result.user.email, equals('test@example.com'));
        
        verify(mockDio.post(
          '/user/register',
          data: TestData.testRegisterRequest.toJson(),
        )).called(1);
      });

      test('should throw DioException when register fails', () async {
        // Arrange
        when(mockDio.post(
          '/user/register',
          data: anyNamed('data'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/user/register'),
          response: Response(
            statusCode: 400,
            statusMessage: 'Bad Request',
            requestOptions: RequestOptions(path: '/user/register'),
            data: {'error': 'Email already exists'},
          ),
        ));

        // Act & Assert
        expect(
          () => dataSource.register(TestData.testRegisterRequest),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('logout', () {
      test('should perform POST request to /user/logout', () async {
        // Arrange
        when(mockDio.post('/user/logout')).thenAnswer((_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: '/user/logout'),
        ));

        // Act
        await dataSource.logout();

        // Assert
        verify(mockDio.post('/user/logout')).called(1);
      });

      test('should handle logout errors', () async {
        // Arrange
        when(mockDio.post('/user/logout')).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/user/logout'),
          response: Response(
            statusCode: 500,
            statusMessage: 'Internal Server Error',
            requestOptions: RequestOptions(path: '/user/logout'),
          ),
        ));

        // Act & Assert
        expect(
          () => dataSource.logout(),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('getCurrentUser', () {
      test('should perform GET request to /user/profile and return UserModel', () async {
        // Arrange
        when(mockDio.get('/user/profile')).thenAnswer((_) async => Response(
          data: TestData.testUserJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/user/profile'),
        ));

        // Act
        final result = await dataSource.getCurrentUser();

        // Assert
        expect(result, isA<UserModel>());
        expect(result.email, equals('test@example.com'));
        expect(result.name, equals('Test User'));
        expect(result.profileImageUrl, equals('https://example.com/profile.jpg'));
        
        verify(mockDio.get('/user/profile')).called(1);
      });

      test('should throw DioException when getCurrentUser fails', () async {
        // Arrange
        when(mockDio.get('/user/profile')).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/user/profile'),
          response: Response(
            statusCode: 401,
            statusMessage: 'Unauthorized',
            requestOptions: RequestOptions(path: '/user/profile'),
          ),
        ));

        // Act & Assert
        expect(
          () => dataSource.getCurrentUser(),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('refreshToken', () {
      test('should perform POST request to /user/refresh and return AuthResponse', () async {
        // Arrange
        final refreshTokenData = {'refresh_token': 'refresh_token_123'};
        final responseData = TestData.testAuthResponseJson;
        
        when(mockDio.post(
          '/user/refresh',
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/user/refresh'),
        ));

        // Act
        final result = await dataSource.refreshToken(refreshTokenData);

        // Assert
        expect(result, isA<AuthResponse>());
        expect(result.token, equals('test_token_123'));
        
        verify(mockDio.post(
          '/user/refresh',
          data: refreshTokenData,
        )).called(1);
      });

      test('should throw DioException when refresh token fails', () async {
        // Arrange
        final refreshTokenData = {'refresh_token': 'invalid_token'};
        
        when(mockDio.post(
          '/user/refresh',
          data: anyNamed('data'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/user/refresh'),
          response: Response(
            statusCode: 401,
            statusMessage: 'Unauthorized',
            requestOptions: RequestOptions(path: '/user/refresh'),
            data: {'error': 'Invalid refresh token'},
          ),
        ));

        // Act & Assert
        expect(
          () => dataSource.refreshToken(refreshTokenData),
          throwsA(isA<DioException>()),
        );
      });
    });
  });
}
