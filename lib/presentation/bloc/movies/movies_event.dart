import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

class MoviesLoadRequested extends MoviesEvent {
  final bool isRefresh;

  const MoviesLoadRequested({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class MoviesLoadMoreRequested extends MoviesEvent {}

class MoviesSearchRequested extends MoviesEvent {
  final String query;

  const MoviesSearchRequested(this.query);

  @override
  List<Object> get props => [query];
}

class MoviesFavoriteToggled extends MoviesEvent {
  final Movie movie;

  const MoviesFavoriteToggled(this.movie);

  @override
  List<Object> get props => [movie];
}

class MoviesRefreshRequested extends MoviesEvent {}
