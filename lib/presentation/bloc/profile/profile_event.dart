import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileLoadFavoriteMovies extends ProfileEvent {
  const ProfileLoadFavoriteMovies();
}

class ProfileRefreshFavoriteMovies extends ProfileEvent {
  const ProfileRefreshFavoriteMovies();
}
