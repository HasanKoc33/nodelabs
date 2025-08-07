import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final List<String>? favoriteMovies;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.favoriteMovies,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    List<String>? favoriteMovies,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
    );
  }

  @override
  List<Object?> get props => [id, email, name, profileImageUrl, favoriteMovies];
}
