import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel extends Movie {
  @JsonKey(name: 'posterUrl')
  final String? posterUrl;
  @JsonKey(name: 'Plot')
  final String? description;

  const MovieModel({
    required String id,
    required String title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    double? voteAverage,
    int? voteCount,
    bool isFavorite = false,
    List<String>? genres,
    this.posterUrl,
    this.description,
  }) : super(
          id: id,
          title: title,
          overview: overview,
          posterPath: posterPath,
          backdropPath: backdropPath,
          releaseDate: releaseDate,
          voteAverage: voteAverage,
          voteCount: voteCount,
          isFavorite: isFavorite,
          genres: genres,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    // id can come as both int and string, convert to string.
    final dynamic idRaw = json['id'];
    String parsedId;
    if (idRaw is int) {
      parsedId = idRaw.toString();
    } else if (idRaw is String) {
      parsedId = idRaw;
    } else {
      parsedId = '';
    }
    return MovieModel(
      id: parsedId,
      title: json['Title'] as String,
      overview: json['Plot'] as String?,
      posterPath: json['Poster'] as String?,
      backdropPath: json['backdropPath'] as String?,
      releaseDate: json['releaseDate'] as String?,
      voteAverage: (json['voteAverage'] is int)
          ? (json['voteAverage'] as int).toDouble()
          : json['voteAverage'] as double?,
      voteCount: json['voteCount'] as int?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      genres: (json['genres'] as List?)?.map((e) => e.toString()).toList(),
      posterUrl: json['posterUrl'] as String?,
      description: json['Plot'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      releaseDate: movie.releaseDate,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
      isFavorite: movie.isFavorite,
      genres: movie.genres,
      posterUrl: movie.posterPath,
      description: movie.overview,
    );
  }
}

@JsonSerializable()
class MovieListResponse {
  final List<MovieModel> movies;
  final int totalPages;
  final int currentPage;

  const MovieListResponse({
    required this.movies,
    required this.totalPages,
    required this.currentPage,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is List) {
      // If API returns just a list of movies (no pagination)
      return MovieListResponse(
        movies: data.map((movie) => MovieModel.fromJson(movie as Map<String, dynamic>)).toList(),
        totalPages: 1,
        currentPage: 1,
      );
    } else if (data is Map<String, dynamic>) {
      final pagination = data['pagination'] as Map<String, dynamic>?;
      final moviesJson = data['movies'] as List<dynamic>? ?? [];
      return MovieListResponse(
        movies: moviesJson.map((movie) => MovieModel.fromJson(movie as Map<String, dynamic>)).toList(),
        totalPages: pagination?['maxPage'] as int? ?? 1,
        currentPage: pagination?['currentPage'] as int? ?? 1,
      );
    } else {
      // Fallback: empty list
      return MovieListResponse(
        movies: [],
        totalPages: 1,
        currentPage: 1,
      );
    }
  }
  
  Map<String, dynamic> toJson() => _$MovieListResponseToJson(this);
}
