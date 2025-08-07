import 'package:flutter_test/flutter_test.dart';
import 'package:nodelabs/data/models/movie_model.dart';
import 'package:nodelabs/domain/entities/movie.dart';
import '../../helpers/test_data.dart';

void main() {
  group('MovieModel', () {
    test('should be a subclass of Movie entity', () {
      // Assert
      expect(TestData.testMovieModel, isA<Movie>());
    });

    group('fromJson', () {
      test('should return a valid MovieModel from JSON', () {
        // Act
        final result = MovieModel.fromJson(TestData.testMovieJson);

        // Assert
        expect(result, equals(TestData.testMovieModel));
      });

      test('should handle null optional fields', () {
        // Arrange
        final jsonWithNulls = {
          'id': 1,
          'Title': 'Test Movie',
          'Plot': 'This is a test movie',
          'Poster': '/test_poster.jpg',
          'backdropPath': '/test_backdrop.jpg',
          'releaseDate': '2023-01-01',
          'voteAverage': 8.5,
          'voteCount': 1000,
          'isFavorite': false,
          'genres': null,
        };

        // Act
        final result = MovieModel.fromJson(jsonWithNulls);

        // Assert
        expect(result.id, '1');
        expect(result.title, 'Test Movie');
        expect(result.genres, null);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = TestData.testMovieModel.toJson();

        // Assert
        expect(result, TestData.testMovieJson);
      });
    });

    group('fromEntity', () {
      test('should create MovieModel from Movie entity', () {
        // Act
        final result = MovieModel.fromEntity(TestData.testMovie);

        // Assert
        expect(result.id, TestData.testMovie.id);
        expect(result.title, TestData.testMovie.title);
        expect(result.overview, TestData.testMovie.overview);
        expect(result.posterPath, TestData.testMovie.posterPath);
        expect(result.backdropPath, TestData.testMovie.backdropPath);
        expect(result.releaseDate, TestData.testMovie.releaseDate);
        expect(result.voteAverage, TestData.testMovie.voteAverage);
        expect(result.voteCount, TestData.testMovie.voteCount);
        expect(result.isFavorite, TestData.testMovie.isFavorite);
        expect(result.genres, TestData.testMovie.genres);
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        // Arrange
        const movieModel1 = MovieModel(
          id: 'aasd123',
          title: 'Test',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          backdropPath: '/backdrop.jpg',
          releaseDate: '2023-01-01',
          voteAverage: 8.0,
          voteCount: 100,
          isFavorite: false,
        );
        const movieModel2 = MovieModel(
          id: 'aasd123',
          title: 'Test',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          backdropPath: '/backdrop.jpg',
          releaseDate: '2023-01-01',
          voteAverage: 8.0,
          voteCount: 100,
          isFavorite: false,
        );

        // Assert
        expect(movieModel1, equals(movieModel2));
      });

      test('should not be equal when properties differ', () {
        // Arrange
        const movieModel1 = MovieModel(
          id: 'aasd123',
          title: 'Test',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          backdropPath: '/backdrop.jpg',
          releaseDate: '2023-01-01',
          voteAverage: 8.0,
          voteCount: 100,
          isFavorite: false,
        );
        const movieModel2 = MovieModel(
          id: 'aasd123',
          title: 'Test',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          backdropPath: '/backdrop.jpg',
          releaseDate: '2023-01-01',
          voteAverage: 8.0,
          voteCount: 100,
          isFavorite: false,
        );

        // Assert
        expect(movieModel1, isNot(equals(movieModel2)));
      });
    });
  });

  group('MovieListResponse', () {
    group('fromJson', () {
      test('should return a valid MovieListResponse from JSON', () {
        // Act
        final result = MovieListResponse.fromJson(TestData.testMoviesListJson);

        // Assert
        expect(result.currentPage, 1);
        expect(result.totalPages, 10);
        expect(result.movies.length, 1);
        expect(result.movies.first.id, 1);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Arrange
        const movieListResponse = MovieListResponse(
          movies: [TestData.testMovieModel],
          totalPages: 10,
          currentPage: 1,
        );

        // Act
        final result = movieListResponse.toJson();

        // Assert
        expect(result['movies'], isA<List>());
        expect((result['movies'] as List).length, 1);
        expect(result['totalPages'], 10);
        expect(result['currentPage'], 1);
      });
    });
  });
}
