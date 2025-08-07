import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:nodelabs/core/error/exceptions.dart';
import 'package:nodelabs/core/error/failures.dart';
import 'package:nodelabs/data/repositories/auth_repository_impl.dart';
import 'package:nodelabs/data/models/auth_model.dart';
import 'package:nodelabs/data/models/user_model.dart';
import '../../helpers/test_helper.mocks.dart';
import '../../helpers/test_data.dart';

// Using generated mocks from test_helper.mocks.dart

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repository;
    late MockAuthRemoteDataSource mockRemoteDataSource;
    late MockAuthLocalDataSource mockLocalDataSource;
    late MockNetworkInfo mockNetworkInfo;

    setUp(() {
      mockRemoteDataSource = MockAuthRemoteDataSource();
      mockLocalDataSource = MockAuthLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      
      repository = AuthRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo,
      );
    });

    void runTestsOnline(Function body) {
      group('device is online', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });

        body();
      });
    }

    void runTestsOffline(Function body) {
      group('device is offline', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });

        body();
      });
    }

    group('login', () {
      const email = 'test@example.com';
      const password = 'password123';

      runTestsOnline(() {
        test('should return User when login is successful', () async {
          // Arrange
          when(mockRemoteDataSource.login(any))
              .thenAnswer((_) async => TestData.testAuthResponse);
          when(mockLocalDataSource.saveToken(any)).thenAnswer((_) async {});
          when(mockLocalDataSource.saveUser(any)).thenAnswer((_) async {});

          // Act
          final result = await repository.login(email, password);

          // Assert
          expect(result, isA<Right>());
          result.fold(
            (failure) => fail('Should return User'),
            (user) {
              expect(user.email, equals(email));
              expect(user.name, equals('Test User'));
            },
          );

          verify(mockRemoteDataSource.login(any)).called(1);
          verify(mockLocalDataSource.saveToken(TestData.testAuthResponse.token)).called(1);
          verify(mockLocalDataSource.saveUser(any)).called(1);
        });

        test('should return ServerFailure when server throws ServerException', () async {
          // Arrange
          when(mockRemoteDataSource.login(any))
              .thenThrow(const ServerException('Server error'));

          // Act
          final result = await repository.login(email, password);

          // Assert
          expect(result, isA<Left>());
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (user) => fail('Should return ServerFailure'),
          );
        });

        test('should return AuthFailure when server throws AuthException', () async {
          // Arrange
          when(mockRemoteDataSource.login(any))
              .thenThrow(const AuthException('Invalid credentials'));

          // Act
          final result = await repository.login(email, password);

          // Assert
          expect(result, isA<Left>());
          result.fold(
            (failure) => expect(failure, isA<AuthFailure>()),
            (user) => fail('Should return AuthFailure'),
          );
        });

        test('should return ServerFailure when unexpected error occurs', () async {
          // Arrange
          when(mockRemoteDataSource.login(any))
              .thenThrow(Exception('Unexpected error'));

          // Act
          final result = await repository.login(email, password);

          // Assert
          expect(result, isA<Left>());
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (user) => fail('Should return ServerFailure'),
          );
        });
      });

      runTestsOffline(() {
        test('should return NetworkFailure when device is offline', () async {
          // Act
          final result = await repository.login(email, password);

          // Assert
          expect(result, isA<Left>());
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (user) => fail('Should return NetworkFailure'),
          );

          verifyNever(mockRemoteDataSource.login(any));
        });
      });
    });

    group('register', () {
      const name = 'Test User';
      const email = 'test@example.com';
      const password = 'password123';

      runTestsOnline(() {
        test('should return User when registration is successful', () async {
          // Arrange
          when(mockRemoteDataSource.register(any))
              .thenAnswer((_) async => TestData.testAuthResponse);
          when(mockLocalDataSource.saveToken(any)).thenAnswer((_) async {});
          when(mockLocalDataSource.saveUser(any)).thenAnswer((_) async {});

          // Act
          final result = await repository.register(name, email, password);

          // Assert
          expect(result, isA<Right>());
          result.fold(
            (failure) => fail('Should return User'),
            (user) {
              expect(user.email, equals(email));
              expect(user.name, equals(name));
            },
          );

          verify(mockRemoteDataSource.register(any)).called(1);
          verify(mockLocalDataSource.saveToken(TestData.testAuthResponse.token)).called(1);
          verify(mockLocalDataSource.saveUser(any)).called(1);
        });

        test('should return AuthFailure when registration fails', () async {
          // Arrange
          when(mockRemoteDataSource.register(any))
              .thenThrow(const AuthException('Email already exists'));

          // Act
          final result = await repository.register(name, email, password);

          // Assert
          expect(result, isA<Left>());
          result.fold(
            (failure) => expect(failure, isA<AuthFailure>()),
            (user) => fail('Should return AuthFailure'),
          );
        });
      });

      runTestsOffline(() {
        test('should return NetworkFailure when device is offline', () async {
          // Act
          final result = await repository.register(name, email, password);

          // Assert
          expect(result, isA<Left>());
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (user) => fail('Should return NetworkFailure'),
          );
        });
      });
    });

    group('logout', () {
      runTestsOnline(() {
        test('should logout successfully when online', () async {
          // Arrange
          when(mockRemoteDataSource.logout()).thenAnswer((_) async {});
          when(mockLocalDataSource.deleteToken()).thenAnswer((_) async {});
          when(mockLocalDataSource.deleteUser()).thenAnswer((_) async {});

          // Act
          final result = await repository.logout();

          // Assert
          expect(result, isA<Right>());
          verify(mockRemoteDataSource.logout()).called(1);
          verify(mockLocalDataSource.deleteToken()).called(1);
          verify(mockLocalDataSource.deleteUser()).called(1);
        });

        test('should logout locally even when remote logout fails', () async {
          // Arrange
          when(mockRemoteDataSource.logout())
              .thenThrow(const ServerException('Server error'));
          when(mockLocalDataSource.deleteToken()).thenAnswer((_) async {});
          when(mockLocalDataSource.deleteUser()).thenAnswer((_) async {});

          // Act
          final result = await repository.logout();

          // Assert
          expect(result, isA<Right>());
          verify(mockLocalDataSource.deleteToken()).called(1);
          verify(mockLocalDataSource.deleteUser()).called(1);
        });
      });

      runTestsOffline(() {
        test('should logout locally when offline', () async {
          // Arrange
          when(mockLocalDataSource.deleteToken()).thenAnswer((_) async {});
          when(mockLocalDataSource.deleteUser()).thenAnswer((_) async {});

          // Act
          final result = await repository.logout();

          // Assert
          expect(result, isA<Right>());
          verifyNever(mockRemoteDataSource.logout());
          verify(mockLocalDataSource.deleteToken()).called(1);
          verify(mockLocalDataSource.deleteUser()).called(1);
        });
      });

      test('should return CacheFailure when local logout fails', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockLocalDataSource.deleteToken())
            .thenThrow(const CacheException('Failed to delete token'));

        // Act
        final result = await repository.logout();

        // Assert
        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (_) => fail('Should return CacheFailure'),
        );
      });
    });

    group('getCurrentUser', () {
      test('should return User when user exists in cache', () async {
        // Arrange
        when(mockLocalDataSource.getUser())
            .thenAnswer((_) async => TestData.testUserModel);

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result, isA<Right>());
        result.fold(
          (failure) => fail('Should return User'),
          (user) {
            expect(user?.email, equals('test@example.com'));
            expect(user?.name, equals('Test User'));
          },
        );
      });

      test('should return null when no user in cache', () async {
        // Arrange
        when(mockLocalDataSource.getUser()).thenAnswer((_) async => null);

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result, isA<Right>());
        result.fold(
          (failure) => fail('Should return null'),
          (user) => expect(user, isNull),
        );
      });

      test('should return CacheFailure when cache throws exception', () async {
        // Arrange
        when(mockLocalDataSource.getUser())
            .thenThrow(const CacheException('Cache error'));

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (user) => fail('Should return CacheFailure'),
        );
      });
    });

    group('isLoggedIn', () {
      test('should return true when user is logged in', () async {
        // Arrange
        when(mockLocalDataSource.isLoggedIn()).thenAnswer((_) async => true);

        // Act
        final result = await repository.isLoggedIn();

        // Assert
        expect(result, isA<Right>());
        result.fold(
          (failure) => fail('Should return bool'),
          (isLoggedIn) => expect(isLoggedIn, isTrue),
        );
      });

      test('should return false when user is not logged in', () async {
        // Arrange
        when(mockLocalDataSource.isLoggedIn()).thenAnswer((_) async => false);

        // Act
        final result = await repository.isLoggedIn();

        // Assert
        expect(result, isA<Right>());
        result.fold(
          (failure) => fail('Should return bool'),
          (isLoggedIn) => expect(isLoggedIn, isFalse),
        );
      });
    });

    group('refreshToken', () {
      runTestsOnline(() {
        test('should refresh token successfully', () async {
          // Arrange
          const currentToken = 'current_token';
          when(mockLocalDataSource.getToken())
              .thenAnswer((_) async => currentToken);
          when(mockRemoteDataSource.refreshToken(any))
              .thenAnswer((_) async => TestData.testAuthResponse);
          when(mockLocalDataSource.saveToken(any)).thenAnswer((_) async {});

          // Act
          final result = await repository.refreshToken();

          // Assert
          expect(result, isA<Right>());
          verify(mockRemoteDataSource.refreshToken({'refresh_token': currentToken})).called(1);
          verify(mockLocalDataSource.saveToken(TestData.testAuthResponse.token)).called(1);
        });

        test('should return AuthFailure when no token exists', () async {
          // Arrange
          when(mockLocalDataSource.getToken()).thenAnswer((_) async => null);

          // Act
          final result = await repository.refreshToken();

          // Assert
          expect(result, isA<Left>());
          result.fold(
            (failure) => expect(failure, isA<AuthFailure>()),
            (_) => fail('Should return AuthFailure'),
          );
        });
      });

      runTestsOffline(() {
        test('should return NetworkFailure when offline', () async {
          // Act
          final result = await repository.refreshToken();

          // Assert
          expect(result, isA<Left>());
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Should return NetworkFailure'),
          );
        });
      });
    });
  });
}
