import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nodelabs/core/error/failures.dart';
import 'package:nodelabs/domain/repositories/movie_repository.dart';
import 'package:nodelabs/domain/usecases/movie/get_movies_usecase.dart';

import '../../../helpers/test_data.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  group('GetMoviesUseCase', () {
    late GetMoviesUseCase useCase;
    late MockMovieRepository mockMovieRepository;

    setUp(() {
      mockMovieRepository = MockMovieRepository();
      useCase = GetMoviesUseCase(mockMovieRepository);
    });

    const testPage = 1;
    const testParams = GetMoviesParams(page: testPage);
    final testMovieListResult = MovieListResult(
      movies: [TestData.testMovie],
      totalPages: 1,
      currentPage: 1,
    );

    test('should get movies from the repository', () async {
      // arrange
      when(() => mockMovieRepository.getMovies(testPage))
          .thenAnswer((_) async => Right(testMovieListResult));

      // act
      final result = await useCase(testParams);

      // assert
      expect(result, Right(testMovieListResult));
      verify(() => mockMovieRepository.getMovies(testPage)).called(1);
    });

    test('should return ServerFailure when repository returns failure', () async {
      // arrange
      const testFailure = ServerFailure('Server Error');
      when(() => mockMovieRepository.getMovies(testPage))
          .thenAnswer((_) async => const Left(testFailure));

      // act
      final result = await useCase(testParams);

      // assert
      expect(result, const Left(testFailure));
      verify(() => mockMovieRepository.getMovies(testPage)).called(1);
    });

    test('should return NetworkFailure when repository returns network failure', () async {
      // arrange
      const testFailure = NetworkFailure('Network Error');
      when(() => mockMovieRepository.getMovies(testPage))
          .thenAnswer((_) async => const Left(testFailure));

      // act
      final result = await useCase(testParams);

      // assert
      expect(result, const Left(testFailure));
      verify(() => mockMovieRepository.getMovies(testPage)).called(1);
    });
  });
}
