import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:nodelabs/core/error/exceptions.dart';
import 'package:nodelabs/data/datasources/remote/movie_remote_datasource.dart';
import 'package:nodelabs/data/models/movie_model.dart';

import '../../../helpers/test_data.dart';

void main() {
  group('MovieRemoteDataSource', () {
    late MovieRemoteDataSource dataSource;
    late Dio dio;
    late DioAdapter dioAdapter;

    setUp(() {
      dio = Dio(BaseOptions());
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
      dataSource = MovieRemoteDataSource(dio);
    });

    group('getMovies', () {
      final moviesResponseJson = {
        'data': {
          'movies': [
            {
              'id': 1,
              'Title': 'Test Movie',
              'Plot': 'Test plot',
              'Poster': 'test_poster.jpg',
            }
          ],
          'pagination': {
            'totalCount': 1,
            'perPage': 10,
            'maxPage': 1,
            'currentPage': 1,
          }
        }
      };

      test('should return MovieListResponse when the response code is 200', () async {
        // arrange
        dioAdapter.onGet(
          '/movie/list',
          (server) => server.reply(200, moviesResponseJson),
        );

        // act
        final result = await dataSource.getMovies(1);

        // assert
        expect(result, isA<MovieListResponse>());
        expect(result.movies.length, 1);
        expect(result.movies.first.title, 'Test Movie');
      });

      test('should throw ServerException when the response code is 404', () async {
        // arrange
        dioAdapter.onGet(
          '/movie/list',
          (server) => server.reply(404, {'message': 'Not found'}),
        );

        // act & assert
        expect(
          () => dataSource.getMovies(1),
          throwsA(isA<ServerException>()),
        );
      });
    });
  });
}
