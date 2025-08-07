import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nodelabs/data/models/favorite_model.dart';
import 'package:nodelabs/data/models/movie_model.dart';
import 'package:retrofit/retrofit.dart';

part 'movie_remote_datasource.g.dart';

/// Remote data source for movie-related API calls.
@RestApi()
@injectable
abstract class MovieRemoteDataSource {
  @factoryMethod
  /// Creates an instance of [MovieRemoteDataSource] using the provided
  /// [Dio] instance.
  factory MovieRemoteDataSource(Dio dio) = _MovieRemoteDataSource;

  /// Base URL for the API.
  @GET('/movie/list')
  Future<MovieListResponse> getMovies(
    @Query('page') int page,
  );

  /// Fetches popular movies from the API.
  @GET('/movie/popular')
  Future<MovieListResponse> getPopularMovies(
    @Query('api_key') String apiKey,
    @Query('page') int page,
  );

  /// Fetches top-rated movies from the API.
  @GET('/movie/{movie_id}')
  Future<MovieModel> getMovieDetails(
    @Path('movie_id') String movieId,
  );

  /// Adds a movie to the favorites list.
  @POST('/movie/favorite/{favoriteId}')
  Future<FavoriteResponse> togleFavorites(
    @Path('favoriteId') String movieId,
  );

  /// Fetches the list of favorite movies.
  @GET('/movie/favorites')
  Future<MovieListResponse> getFavoriteMovies();

}
