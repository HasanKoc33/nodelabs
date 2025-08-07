import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nodelabs/core/error/failures.dart';
import 'package:nodelabs/domain/repositories/auth_repository.dart';
import 'package:nodelabs/domain/usecases/auth/upload_photo_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockFile extends Mock implements File {}

void main() {
  late UploadPhotoUseCase usecase;
  late MockAuthRepository mockAuthRepository;
  late MockFile mockFile;

  setUp(() {
    mockFile = MockFile();
    mockAuthRepository = MockAuthRepository();
    usecase = UploadPhotoUseCase(mockAuthRepository);
    registerFallbackValue(UploadPhotoParams(file: mockFile));
  });

  group('UploadPhotoUseCase', () {
    final testParams = UploadPhotoParams(file: mockFile);
    const testPhotoUrl = 'https://example.com/uploaded_photo.jpg';

    test('should upload photo from the repository', () async {
      // arrange
      when(() => mockAuthRepository.uploadPhoto(any<File>()))
          .thenAnswer((_) async => const Right(testPhotoUrl));

      // act
      final result = await usecase(testParams);

      // assert
      expect(result, const Right(testPhotoUrl));
      verify(() => mockAuthRepository.uploadPhoto(mockFile));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ServerFailure when repository call fails', () async {
      // arrange
      const failure = ServerFailure('Upload failed');
      when(() => mockAuthRepository.uploadPhoto(any<File>()))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(testParams);

      // assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.uploadPhoto(mockFile));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return NetworkFailure when network call fails', () async {
      // arrange
      const failure = NetworkFailure('Network Error');
      when(() => mockAuthRepository.uploadPhoto(any<File>()))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(testParams);

      // assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.uploadPhoto(mockFile));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when file validation fails', () async {
      // arrange
      const failure = ValidationFailure('Invalid file format');
      when(() => mockAuthRepository.uploadPhoto(any<File>()))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(testParams);

      // assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.uploadPhoto(mockFile));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when authentication fails', () async {
      // arrange
      const failure = AuthFailure('Unauthorized');
      when(() => mockAuthRepository.uploadPhoto(any<File>()))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(testParams);

      // assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.uploadPhoto(mockFile));
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
