import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/domain/entities/movie.dart';
import 'package:nodelabs/presentation/bloc/movies/movies_state.dart';

/// Bloc helper functions and feedback display utility.
/// Helper function to emit both error and feedback in Bloc on error condition.
/// Can be used to show feedback in Bloc.
void emitFeedback(
  Emitter<dynamic> emit,
  String message, {
  bool isError = false,
}) {
  emit(MoviesActionFeedback(message: message, isError: isError));
}

/// Used to transition to error state with error message and optional action message in Bloc.
void emitErrorWithFeedback(
  Emitter<dynamic> emit,
  String errorMessage, {
  List<Movie> movies = const [],
  String? actionMessage,
}) {
  emit(
    MoviesError(
      message: errorMessage,
      movies: movies,
      actionMessage: actionMessage,
    ),
  );
  if (actionMessage != null) {
    emit(MoviesActionFeedback(message: actionMessage, isError: true));
  }
}
