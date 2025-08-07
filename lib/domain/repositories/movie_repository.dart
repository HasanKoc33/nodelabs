import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/movie.dart';

class MovieListResult extends Equatable {
  final List<Movie> movies;
  final int totalPages;
  final int currentPage;

  const MovieListResult({
    required this.movies,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  List<Object> get props => [movies, totalPages, currentPage];
}

abstract class MovieRepository {
  Future<Either<Failure, MovieListResult>> getMovies(int page);
  Future<Either<Failure, Movie>> getMovieDetails(String movieId);
  Future<Either<Failure, List<Movie>>> getFavoriteMovies();
  Future<Either<Failure, void>> addToFavorites(String movieId);
  Future<Either<Failure, void>> removeFromFavorites(String movieId);
}
