import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nodelabs/core/error/failures.dart';
import 'package:nodelabs/domain/entities/user.dart';
import 'package:nodelabs/domain/repositories/auth_repository.dart';
import 'package:nodelabs/domain/usecases/auth/register_usecase.dart';
import '../../../helpers/test_data.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late RegisterUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
  // Register fallback values for custom parameter types used in mocktail
  registerFallbackValue(RegisterParams(name: '', email: '', password: ''));
    mockAuthRepository = MockAuthRepository();
    usecase = RegisterUseCase(mockAuthRepository);
  });

  group('RegisterUseCase', () {
    const testParams = RegisterParams(
      name: 'Test User',
      email: 'test@example.com',
      password: 'password123',
    );

    test('should register user from the repository', () async {
      // arrange
      when(() => mockAuthRepository.register(any<String>(), any<String>(), any<String>())).thenAnswer((_) async => const Right(TestData.testUser));

      // act
      final result = await usecase(testParams);

      // assert
      expect(result, const Right(TestData.testUser));
      verify(() => mockAuthRepository.register('Test User', 'test@example.com', 'password123'));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ServerFailure when repository call fails', () async {
      // arrange
      const failure = ServerFailure('Registration failed');
      when(() => mockAuthRepository.register(any<String>(), any<String>(), any<String>())).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(testParams);

      // assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.register('Test User', 'test@example.com', 'password123'));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return NetworkFailure when network call fails', () async {
      // arrange
      const failure = NetworkFailure('Network Error');
      when(() => mockAuthRepository.register(any<String>(), any<String>(), any<String>())).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(testParams);

      // assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.register('Test User', 'test@example.com', 'password123'));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when validation fails', () async {
      // arrange
      const failure = ValidationFailure('Email already exists');
      when(() => mockAuthRepository.register(any<String>(), any<String>(), any<String>())).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(testParams);

      // assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.register(
          'Test User',
          'test@example.com',
          'password123',
        ));
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
