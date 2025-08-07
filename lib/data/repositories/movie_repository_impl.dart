import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:nodelabs/core/error/exceptions.dart';
import 'package:nodelabs/core/error/failures.dart';
import 'package:nodelabs/core/network/network_info.dart';
import 'package:nodelabs/data/datasources/remote/movie_remote_datasource.dart';
import 'package:nodelabs/domain/entities/movie.dart';
import 'package:nodelabs/domain/repositories/movie_repository.dart';

/// Implementation of [MovieRepository] that handles movie-related operations
@LazySingleton(as: MovieRepository)
final class MovieRepositoryImpl implements MovieRepository {
  /// Creates an instance of [MovieRepositoryImpl].
  const MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  /// Remote data source for movie-related API calls.
  final MovieRemoteDataSource remoteDataSource;

  /// Network information provider to check connectivity.
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, MovieListResult>> getMovies(int page) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getMovies(page);

        // Convert MovieModel list to Movie list
        final movies =
            response.movies
                .map(
                  (movieModel) => Movie(
                    id: movieModel.id,
                    title: movieModel.title,
                    overview: movieModel.description ?? movieModel.overview,
                    posterPath: movieModel.posterUrl ?? movieModel.posterPath,
                    backdropPath: movieModel.backdropPath,
                    releaseDate: movieModel.releaseDate,
                    voteAverage: movieModel.voteAverage,
                    voteCount: movieModel.voteCount,
                    isFavorite: movieModel.isFavorite,
                    genres: movieModel.genres,
                  ),
                )
                .toList();

        return Right(
          MovieListResult(
            movies: movies,
            totalPages: response.totalPages,
            currentPage: response.currentPage,
          ),
        );
      } on DioException catch (e) {
        final errorMessage = _extractErrorMessage(e);
        return Left(ServerFailure(errorMessage));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(ServerFailure('Failed to get movies: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails(String movieId) async {
    if (await networkInfo.isConnected) {
      try {
        final movie = await remoteDataSource.getMovieDetails(movieId);
        return Right(movie);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(ServerFailure('Failed to get movie details: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavoriteMovies() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getFavoriteMovies();

        // Convert MovieModel list to Movie list
        final movies =
            response.movies
                .map(
                  (movieModel) => Movie(
                    id: movieModel.id,
                    title: movieModel.title,
                    overview: movieModel.description ?? movieModel.overview,
                    posterPath: movieModel.posterUrl ?? movieModel.posterPath,
                    backdropPath: movieModel.backdropPath,
                    releaseDate: movieModel.releaseDate,
                    voteAverage: movieModel.voteAverage,
                    voteCount: movieModel.voteCount,
                    isFavorite: true,
                    // All movies from favorites endpoint are favorites
                    genres: movieModel.genres,
                  ),
                )
                .toList();

        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(ServerFailure('${'serverError'.tr()}: $e'));
      }
    } else {
      return Left(CacheFailure('networkError'.tr()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(String movieId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.togleFavorites(movieId);
        if (response.data.action == 'favorited' ||
            response.data.action == 'unfavorited') {
          return const Right(null);
        } else {
          return Left(
            ServerFailure('Unexpected response: ${response.data.action}'),
          );
        }
      } on DioException catch (e) {
        final errorMessage = _extractErrorMessage(e);
        return Left(ServerFailure(errorMessage));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception catch (e) {
        return Left(ServerFailure('Failed to add to favorites: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String movieId) async {
    try {
      await remoteDataSource.togleFavorites(movieId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(CacheFailure('Failed to remove movie from favorites: $e'));
    }
  }

  /// Extracts error message from DioException response
  String _extractErrorMessage(DioException e) {
    try {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          final error =
              (data['response'] as Map<String, dynamic>)['message'] as String?;
          return 'errors.${error ?? 'serverError'}'.tr();
        } else if (data is String) {
          return data;
        }
      }

      // Fallback to DioException message
      return e.message ?? 'errors.networkError'.tr();
    } on Exception catch (_) {
      return 'errors.requestProcessingError'.tr();
    }
  }
}
