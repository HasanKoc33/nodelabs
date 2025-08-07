import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nodelabs/data/models/favorite_model.dart';

import '../../helpers/test_data.dart';

void main() {
  group('FavoriteResponse', () {
    const favoriteResponse = FavoriteResponse(
      data: FavoriteData(
        action: 'favorited',
        movie: TestData.testMovieJson,
      ),
    );

    const favoriteResponseJson = {
      'data': {
        'action': 'favorited',
        'movie': TestData.testMovieJson,
      }
    };

    test('should be a FavoriteResponse instance', () async {
      // assert
      expect(favoriteResponse, isA<FavoriteResponse>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () async {
        // act
        final result = FavoriteResponse.fromJson(favoriteResponseJson);

        // assert
        expect(result, favoriteResponse);
      });

      test('should handle unfavorited action', () async {
        // arrange
        const unfavoriteJson = {
          'data': {
            'action': 'unfavorited',
            'movie': TestData.testMovieJson,
          }
        };

        // act
        final result = FavoriteResponse.fromJson(unfavoriteJson);

        // assert
        expect(result.data.action, 'unfavorited');
        expect(result.data.movie['title'], 'Test Movie');
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () async {
        // act
        final result = favoriteResponse.toJson();

        // assert
        expect(result, favoriteResponseJson);
      });
    });

    // Note: FavoriteResponse doesn't extend Equatable, so no props test
  });

  group('FavoriteData', () {
    const favoriteData = FavoriteData(
      action: 'favorited',
      movie: TestData.testMovieJson,
    );

    const favoriteDataJson = {
      'action': 'favorited',
      'movie': TestData.testMovieJson,
    };

    test('should be a FavoriteData instance', () async {
      // assert
      expect(favoriteData, isA<FavoriteData>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () async {
        // act
        final result = FavoriteData.fromJson(favoriteDataJson);

        // assert
        expect(result, favoriteData);
      });

      test('should handle different action types', () async {
        // arrange
        const unfavoriteJson = {
          'action': 'unfavorited',
          'movie': TestData.testMovieJson,
        };

        // act
        final result = FavoriteData.fromJson(unfavoriteJson);

        // assert
        expect(result.action, 'unfavorited');
        expect(result.movie, TestData.testMovieJson);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () async {
        // act
        final result = favoriteData.toJson();

        // assert
        expect(result, favoriteDataJson);
      });
    });

    // Note: FavoriteData doesn't extend Equatable, so no props test

    // Note: FavoriteData doesn't have copyWith method
  });

  group('JSON Serialization Integration', () {
    test('should serialize and deserialize correctly', () async {
      // arrange
      const originalResponse = FavoriteResponse(
        data: FavoriteData(
          action: 'favorited',
          movie: TestData.testMovieJson,
        ),
      );

      // act
      final jsonString = json.encode(originalResponse.toJson());
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final deserializedResponse = FavoriteResponse.fromJson(jsonMap);

      // assert
      expect(deserializedResponse, originalResponse);
    });

    test('should handle nested JSON correctly', () async {
      // arrange
      const complexJson = {
        'data': {
          'action': 'favorited',
          'movie': {
            'id': 'complex_id',
            'title': 'Complex Movie',
            'overview': 'Complex overview with special characters: àáâãäå',
            'posterPath': '/complex_poster.jpg',
            'backdropPath': '/complex_backdrop.jpg',
            'releaseDate': '2023-12-31',
            'voteAverage': 9.5,
            'voteCount': 10000,
            'isFavorite': true,
            'genres': ['Action', 'Adventure', 'Sci-Fi'],
          }
        }
      };

      // act
      final result = FavoriteResponse.fromJson(complexJson);

      // assert
      expect(result.data.action, 'favorited');
      expect(result.data.movie['title'], 'Complex Movie');
      expect(result.data.movie['overview'], 'Complex overview with special characters: àáâãäå');
      expect(result.data.movie['genres'], ['Action', 'Adventure', 'Sci-Fi']);
    });
  });
}
