import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:nodelabs/core/error/failures.dart';
import 'package:nodelabs/domain/usecases/auth/login_usecase.dart';
import 'package:nodelabs/domain/entities/user.dart';
import '../../../helpers/test_helper.dart';
import '../../../helpers/test_data.dart';

void main() {
  group('LoginUseCase', () {
    late LoginUseCase useCase;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
  // Register fallback values for custom parameter types used in mocktail
  registerFallbackValue(LoginParams(email: '', password: ''));
      mockAuthRepository = MockAuthRepository();
      useCase = LoginUseCase(mockAuthRepository);
    });

    test('should get User from the repository when login is successful', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const params = LoginParams(email: email, password: password);

      when(() => mockAuthRepository.login(email, password))
          .thenAnswer((_) async => const Right(TestData.testUser));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Should return User'),
        (user) {
          expect(user, equals(TestData.testUser));
          expect(user.email, equals(email));
        },
      );

      verify(() => mockAuthRepository.login(email, password)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when login fails with invalid credentials', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'wrong_password';
      const params = LoginParams(email: email, password: password);

      when(() => mockAuthRepository.login(email, password))
          .thenAnswer((_) async => const Left(AuthFailure('Invalid credentials')));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, equals('Invalid credentials'));
        },
        (user) => fail('Should return AuthFailure'),
      );

      verify(() => mockAuthRepository.login(email, password)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ServerFailure when server error occurs', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const params = LoginParams(email: email, password: password);

      when(() => mockAuthRepository.login(email, password))
          .thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, equals('Server error'));
        },
        (user) => fail('Should return ServerFailure'),
      );

      verify(() => mockAuthRepository.login(email, password)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return NetworkFailure when no internet connection', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const params = LoginParams(email: email, password: password);

      when(() => mockAuthRepository.login(email, password))
          .thenAnswer((_) async => const Left(NetworkFailure('No internet connection')));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, equals('No internet connection'));
        },
        (user) => fail('Should return NetworkFailure'),
      );

      verify(() => mockAuthRepository.login(email, password)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    group('LoginParams', () {
      test('should be equal when all properties are the same', () {
        // Arrange
        const params1 = LoginParams(
          email: 'test@example.com',
          password: 'password123',
        );
        const params2 = LoginParams(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(params1, equals(params2));
      });

      test('should not be equal when properties differ', () {
        // Arrange
        const params1 = LoginParams(
          email: 'test@example.com',
          password: 'password123',
        );
        const params2 = LoginParams(
          email: 'test@example.com',
          password: 'different_password',
        );

        // Assert
        expect(params1, isNot(equals(params2)));
      });

      test('should have correct props', () {
        // Arrange
        const params = LoginParams(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(params.props, equals(['test@example.com', 'password123']));
      });
    });
  });
}
