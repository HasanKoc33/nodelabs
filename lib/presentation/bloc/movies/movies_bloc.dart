import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nodelabs/core/services/logger_service.dart';
import 'package:nodelabs/domain/usecases/movie/add_to_favorites_usecase.dart';
import 'package:nodelabs/domain/usecases/movie/get_movies_usecase.dart';
import 'package:nodelabs/presentation/bloc/bloc_utils.dart';
import 'package:nodelabs/presentation/bloc/movies/movies_event.dart';
import 'package:nodelabs/presentation/bloc/movies/movies_state.dart';

/// Bloc for managing movie-related events and states
@injectable
final class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  /// Creates an instance of [MoviesBloc].
  MoviesBloc(this._getMoviesUseCase, this._addToFavoritesUseCase, this._logger)
    : super(MoviesInitial()) {
    on<MoviesLoadRequested>(_onMoviesLoadRequested);
    on<MoviesLoadMoreRequested>(_onMoviesLoadMoreRequested);
    on<MoviesRefreshRequested>(_onMoviesRefreshRequested);
    on<MoviesFavoriteToggled>(_onMoviesFavoriteToggled);
  }

  final GetMoviesUseCase _getMoviesUseCase;
  final AddToFavoritesUseCase _addToFavoritesUseCase;
  final LoggerService _logger;

  Future<void> _onMoviesLoadRequested(
    MoviesLoadRequested event,
    Emitter<MoviesState> emit,
  ) async {
    if (event.isRefresh && state is MoviesLoaded) {
      final currentState = state as MoviesLoaded;
      emit(currentState.copyWith(isRefreshing: true));
    } else {
      emit(MoviesLoading());
    }

    final result = await _getMoviesUseCase(const GetMoviesParams(page: 1));

    result.fold(
      (failure) {
        _logger.error('Failed to load movies: {failure.message}');
        emitErrorWithFeedback(emit, failure.message);
      },
      (movieListResult) {
        _logger.info('Loaded ${movieListResult.movies.length} movies');
        emit(
          MoviesLoaded(
            movies: movieListResult.movies,
            hasReachedMax:
                movieListResult.currentPage >= movieListResult.totalPages,
            currentPage: movieListResult.currentPage,
          ),
        );
      },
    );
  }

  Future<void> _onMoviesLoadMoreRequested(
    MoviesLoadMoreRequested event,
    Emitter<MoviesState> emit,
  ) async {
    if (state is MoviesLoaded) {
      final currentState = state as MoviesLoaded;

      if (currentState.hasReachedMax) return;

      emit(
        MoviesLoadingMore(
          movies: currentState.movies,
          currentPage: currentState.currentPage,
        ),
      );

      final nextPage = currentState.currentPage + 1;
      final result = await _getMoviesUseCase(GetMoviesParams(page: nextPage));

      result.fold(
        (failure) {
          _logger.error('Failed to load more movies: {failure.message}');
          emitErrorWithFeedback(
            emit,
            failure.message,
            movies: currentState.movies,
          );
        },
        (movieListResult) {
          _logger.info('Loaded ${movieListResult.movies.length} more movies');
          final allMovies = List.of(currentState.movies)
            ..addAll(movieListResult.movies);

          emit(
            MoviesLoaded(
              movies: allMovies,
              hasReachedMax:
                  movieListResult.currentPage >= movieListResult.totalPages,
              currentPage: movieListResult.currentPage,
            ),
          );
        },
      );
    }
  }

  Future<void> _onMoviesRefreshRequested(
    MoviesRefreshRequested event,
    Emitter<MoviesState> emit,
  ) async {
    add(const MoviesLoadRequested(isRefresh: true));
  }

  Future<void> _onMoviesFavoriteToggled(
    MoviesFavoriteToggled event,
    Emitter<MoviesState> emit,
  ) async {
    final result = await _addToFavoritesUseCase(
      AddToFavoritesParams(movieId: event.movie.id),
    );

    result.fold(
      (failure) {
        _logger.error('Failed to toggle favorite: ${failure.message}');
        // Don't emit feedback, let UI handle the error
      },
      (_) {
        _logger.info('Toggled favorite for movie: ${event.movie.title}');

        // Update the movie in the current state
        if (state is MoviesLoaded) {
          final currentState = state as MoviesLoaded;
          final updatedMovies =
              currentState.movies.map((movie) {
                if (movie.id == event.movie.id) {
                  return movie.copyWith(isFavorite: !movie.isFavorite);
                }
                return movie;
              }).toList();

          // Only emit updated movies state
          emit(currentState.copyWith(movies: updatedMovies));
        }
      },
    );
  }
}
