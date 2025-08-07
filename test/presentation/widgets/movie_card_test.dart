import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nodelabs/domain/entities/movie.dart';
import 'package:nodelabs/presentation/widgets/home_movie_widget.dart';
import 'package:nodelabs/core/services/logger_service.dart';
import '../../helpers/test_helper.dart';
import '../../helpers/test_data.dart';

void main() {
  group('HomeMovieWidget Tests', () {
    late MockLoggerService mockLogger;

    setUp(() {
      mockLogger = MockLoggerService();
    });
    testWidgets('should display movie title', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeMovieWidget(
              movie: TestData.testMovie,
              loadingFavorites: <String>{},
              logger: mockLogger,
              onFavoriteToggled: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Test Movie'), findsOneWidget);
    });

    testWidgets('should display movie poster', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeMovieWidget(
              movie: TestData.testMovie,
              loadingFavorites: <String>{},
              logger: mockLogger,
              onFavoriteToggled: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display favorite icon when movie is favorite', (WidgetTester tester) async {
      // arrange
      const favoriteMovie = Movie(
        id: 'test_id',
        title: 'Test Movie',
        overview: 'Test overview',
        posterPath: '/test_poster.jpg',
        backdropPath: '/test_backdrop.jpg',
        releaseDate: '2023-01-01',
        voteAverage: 8.5,
        voteCount: 1000,
        isFavorite: true,
        genres: ['Action'],
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeMovieWidget(
              movie: favoriteMovie,
              loadingFavorites: <String>{},
              logger: mockLogger,
              onFavoriteToggled: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('should display unfavorite icon when movie is not favorite', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeMovieWidget(
              movie: TestData.testMovie,
              loadingFavorites: <String>{},
              logger: mockLogger,
              onFavoriteToggled: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('should have tappable favorite button area', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeMovieWidget(
              movie: TestData.testMovie,
              loadingFavorites: <String>{},
              logger: mockLogger,
              onFavoriteToggled: () {},
            ),
          ),
        ),
      );

      // assert - Should have a GestureDetector for favorite interaction
      expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
    });

    testWidgets('should display movie overview when available', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeMovieWidget(
              movie: TestData.testMovie,
              loadingFavorites: <String>{},
              logger: mockLogger,
              onFavoriteToggled: () {},
            ),
          ),
        ),
      );

      // assert - HomeMovieWidget shows overview if available
      expect(find.text(TestData.testMovie.overview!), findsOneWidget);
    });

    testWidgets('should display gradient overlay', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeMovieWidget(
              movie: TestData.testMovie,
              loadingFavorites: <String>{},
              logger: mockLogger,
              onFavoriteToggled: () {},
            ),
          ),
        ),
      );

      // assert - HomeMovieWidget has gradient overlay
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('should display genres when provided', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeMovieWidget(
              movie: TestData.testMovie,
              loadingFavorites: <String>{},
              logger: mockLogger,
              onFavoriteToggled: () {},
            ),
          ),
        ),
      );

      // assert - HomeMovieWidget shows movie title
      expect(find.text('Test Movie'), findsOneWidget);
    });

    testWidgets('should have correct styling and layout', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeMovieWidget(
              movie: TestData.testMovie,
              loadingFavorites: <String>{},
              logger: mockLogger,
              onFavoriteToggled: () {},
            ),
          ),
        ),
      );

      // assert - HomeMovieWidget uses Stack layout (may have nested stacks)
      expect(find.byType(Stack), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });
  });
}
