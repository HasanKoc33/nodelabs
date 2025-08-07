import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileFavoriteMoviesLoading extends ProfileState {
  const ProfileFavoriteMoviesLoading();
}

class ProfileFavoriteMoviesLoaded extends ProfileState {
  final List<Movie> favoriteMovies;

  const ProfileFavoriteMoviesLoaded(this.favoriteMovies);

  @override
  List<Object> get props => [favoriteMovies];
}

class ProfileFavoriteMoviesError extends ProfileState {
  final String message;

  const ProfileFavoriteMoviesError(this.message);

  @override
  List<Object> get props => [message];
}
