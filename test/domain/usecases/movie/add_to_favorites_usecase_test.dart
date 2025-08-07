import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nodelabs/core/error/failures.dart';
import 'package:nodelabs/domain/repositories/movie_repository.dart';
import 'package:nodelabs/domain/usecases/movie/add_to_favorites_usecase.dart';

import '../../../helpers/test_data.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  group('AddToFavoritesUseCase', () {
    late AddToFavoritesUseCase useCase;
    late MockMovieRepository mockMovieRepository;

    setUp(() {
      mockMovieRepository = MockMovieRepository();
      useCase = AddToFavoritesUseCase(mockMovieRepository);
    });

    const testMovieId = 'test_movie_id';
    const testParams = AddToFavoritesParams(movieId: testMovieId);

    test('should add movie to favorites when call to repository is successful', () async {
      // arrange
      when(() => mockMovieRepository.addToFavorites(testMovieId))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase(testParams);

      // assert
      expect(result, const Right(null));
      verify(() => mockMovieRepository.addToFavorites(testMovieId)).called(1);
    });

    test('should return ServerFailure when call to repository fails', () async {
      // arrange
      const testFailure = ServerFailure('Server Error');
      when(() => mockMovieRepository.addToFavorites(testMovieId))
          .thenAnswer((_) async => const Left(testFailure));

      // act
      final result = await useCase(testParams);

      // assert
      expect(result, const Left(testFailure));
      verify(() => mockMovieRepository.addToFavorites(testMovieId)).called(1);
    });

    test('should return NetworkFailure when call to repository fails with network error', () async {
      // arrange
      const testFailure = NetworkFailure('Network Error');
      when(() => mockMovieRepository.addToFavorites(testMovieId))
          .thenAnswer((_) async => const Left(testFailure));

      // act
      final result = await useCase(testParams);

      // assert
      expect(result, const Left(testFailure));
      verify(() => mockMovieRepository.addToFavorites(testMovieId)).called(1);
    });
  });
}
