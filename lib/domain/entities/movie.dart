import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double? voteAverage;
  final int? voteCount;
  final bool isFavorite;
  final List<String>? genres;

  const Movie({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
    this.isFavorite = false,
    this.genres,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    double? voteAverage,
    int? voteCount,
    bool? isFavorite,
    List<String>? genres,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      isFavorite: isFavorite ?? this.isFavorite,
      genres: genres ?? this.genres,
    );
  }

  String get finalPosterPath {
    if (posterPath == null || posterPath!.isEmpty) {
      return '';
    }
    var uri = Uri.parse(posterPath!);
    if (uri.scheme == 'http') {
      uri = uri.replace(scheme: 'https');
    }
    return uri.toString();
  }

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        releaseDate,
        voteAverage,
        voteCount,
        isFavorite,
        genres,
      ];
}
