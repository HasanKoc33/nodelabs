import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nodelabs/core/error/exceptions.dart';
import 'package:nodelabs/core/error/failures.dart';
import 'package:nodelabs/core/network/network_info.dart';
import 'package:nodelabs/data/datasources/remote/movie_remote_datasource.dart';
import 'package:nodelabs/data/models/favorite_model.dart';
import 'package:nodelabs/data/models/movie_model.dart';
import 'package:nodelabs/data/repositories/movie_repository_impl.dart';
import 'package:nodelabs/domain/repositories/movie_repository.dart';

import '../../helpers/test_data.dart';
import '../../helpers/test_helper.dart';

void main() {
  group('MovieRepositoryImpl', () {
    late MovieRepositoryImpl repository;
    late MockMovieRemoteDataSource mockRemoteDataSource;

    setUp(() {
      mockRemoteDataSource = MockMovieRemoteDataSource();
      final mockNetworkInfo = MockNetworkInfo();
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository = MovieRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        networkInfo: mockNetworkInfo,
      );
    });

    group('getMovies', () {
      test('should return movies when call to remote data source is successful', () async {
        // arrange
        final mockResponse = MovieListResponse(
          movies: [TestData.testMovieModel],
          totalPages: 1,
          currentPage: 1,
        );
        when(() => mockRemoteDataSource.getMovies(any<int>()))
            .thenAnswer((_) async => mockResponse);

        // act
        final result = await repository.getMovies(1);

        // assert
        expect(result, isA<Right<Failure, MovieListResult>>()); 
        result.fold(
          (_) => fail('Expected Right but got Left'),
          (movieListResult) {
            expect(movieListResult.movies, isNotEmpty);
            expect(movieListResult.movies.first.title, TestData.testMovieModel.title);
          },
        );
        verify(() => mockRemoteDataSource.getMovies(1)).called(1);
      });

      test('should return ServerFailure when remote data source throws ServerException', () async {
        // arrange
        when(() => mockRemoteDataSource.getMovies(any<int>()))
            .thenThrow(const ServerException('Server error'));

        // act
        final result = await repository.getMovies(1);

        // assert
        expect(result, isA<Left<Failure, MovieListResult>>());
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Expected Left but got Right'),
        );
      });
    });

    group('addToFavorites', () {
      test('should return success when call to remote data source is successful', () async {
        // arrange
        const testMovieId = 'test_movie_id';
        final mockResponse = FavoriteResponse(
          data: FavoriteData(
            action: 'favorited',
            movie: TestData.testMovieModel.toJson(),
          ),
        );
        when(() => mockRemoteDataSource.togleFavorites(testMovieId))
            .thenAnswer((_) async => mockResponse);

        // act
        final result = await repository.addToFavorites(testMovieId);

        // assert
        expect(result, isA<Right<Failure, void>>());
        verify(() => mockRemoteDataSource.togleFavorites(testMovieId)).called(1);
      });
    });
  });
}
