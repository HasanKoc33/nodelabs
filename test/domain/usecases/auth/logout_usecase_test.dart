import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nodelabs/core/error/failures.dart';
import 'package:nodelabs/domain/repositories/auth_repository.dart';
import 'package:nodelabs/domain/usecases/auth/logout_usecase.dart';
import 'package:nodelabs/domain/usecases/usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
  // Register fallback values for custom parameter types used in mocktail
  registerFallbackValue(NoParams());
    mockAuthRepository = MockAuthRepository();
    usecase = LogoutUseCase(mockAuthRepository);
  });

  group('LogoutUseCase', () {
    test('should logout user from the repository', () async {
      // arrange
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Right(unit));
      verify(() => mockAuthRepository.logout());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ServerFailure when repository call fails', () async {
      // arrange
      const failure = ServerFailure('Logout failed');
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.logout());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return NetworkFailure when network call fails', () async {
      // arrange
      const failure = NetworkFailure('Network Error');
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.logout());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when authentication fails', () async {
      // arrange
      const failure = AuthFailure('Unauthorized');
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.logout());
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
