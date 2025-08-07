import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;
  final bool hasReachedMax;
  final bool isRefreshing;
  final int currentPage;

  const MoviesLoaded({
    required this.movies,
    required this.hasReachedMax,
    this.isRefreshing = false,
    this.currentPage = 1,
  });

  MoviesLoaded copyWith({
    List<Movie>? movies,
    bool? hasReachedMax,
    bool? isRefreshing,
    int? currentPage,
  }) {
    return MoviesLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [movies, hasReachedMax, isRefreshing, currentPage];
}

class MoviesLoadingMore extends MoviesState {
  final List<Movie> movies;
  final int currentPage;

  const MoviesLoadingMore({
    required this.movies,
    required this.currentPage,
  });

  @override
  List<Object> get props => [movies, currentPage];
}

class MoviesError extends MoviesState {
  final String message;
  final List<Movie> movies;
  final String? actionMessage;

  const MoviesError({
    required this.message,
    this.movies = const [],
    this.actionMessage,
  });

  @override
  List<Object> get props => [message, movies, actionMessage ?? ''];
}

/// Can be used to show feedback to the user (snackbar, toast, etc.).
class MoviesActionFeedback extends MoviesState {
  final String message;
  final bool isError;

  const MoviesActionFeedback({required this.message, this.isError = false});

  @override
  List<Object> get props => [message, isError];
}
