import 'package:nodelabs/data/models/auth_model.dart';
import 'package:nodelabs/data/models/user_model.dart';
import 'package:nodelabs/data/models/movie_model.dart';
import 'package:nodelabs/domain/entities/user.dart';
import 'package:nodelabs/domain/entities/movie.dart';

class TestData {
  // Test User Data
  static const testUser = User(
    id: '67bc8d58d9ec4d40040b81b6',
    name: 'Test User',
    email: 'test@example.com',
    profileImageUrl: 'https://example.com/profile.jpg',
    favoriteMovies: ['1', '2', '3'],
  );

  static const testUserModel = UserModel(
    id: '67bc8d58d9ec4d40040b81b6',
    name: 'Test User',
    email: 'test@example.com',
    photoUrl: 'https://example.com/profile.jpg',
    favoriteMovies: ['1', '2', '3'],
  );

  // Test Auth Data
  static const testLoginRequest = LoginRequest(
    email: 'test@example.com',
    password: 'password123',
  );

  static const testRegisterRequest = RegisterRequest(
    name: 'Test User',
    email: 'test@example.com',
    password: 'password123',
  );

  static const testAuthResponse = AuthResponse(
    token: 'test_token_123',
    user: testUserModel,
  );

  // Test Movie Data
  static const testMovie = Movie(
    id: 'asd33',
    title: 'Test Movie',
    overview: 'This is a test movie',
    posterPath: '/test_poster.jpg',
    backdropPath: '/test_backdrop.jpg',
    releaseDate: '2023-01-01',
    voteAverage: 8.5,
    voteCount: 1000,
    isFavorite: false,
    genres: ['Action', 'Drama'],
  );

  static const testMovieModel = MovieModel(
    id: 'asd33',
    title: 'Test Movie',
    overview: 'This is a test movie',
    posterPath: '/test_poster.jpg',
    backdropPath: '/test_backdrop.jpg',
    releaseDate: '2023-01-01',
    voteAverage: 8.5,
    voteCount: 1000,
    isFavorite: false,
  );

  // Test JSON Responses
  static const testUserJson = {
    'id': '67bc8d58d9ec4d40040b81b6',
    'name': 'Test User',
    'email': 'test@example.com',
    'photoUrl': 'https://example.com/profile.jpg',
    'favoriteMovies': ['1', '2', '3'],
  };

  static const testAuthResponseJson = {
    'data': {
      'id': '67bc8d58d9ec4d40040b81b6',
      'name': 'Test User',
      'email': 'test@example.com',
      'photoUrl': 'https://example.com/profile.jpg',
      'favoriteMovies': ['1', '2', '3'],
      'token': 'test_token_123',
    }
  };

  static const testMovieJson = {
    'id': 1,
    'Title': 'Test Movie',
    'Plot': 'This is a test movie',
    'Poster': '/test_poster.jpg',
    'backdropPath': '/test_backdrop.jpg',
    'releaseDate': '2023-01-01',
    'voteAverage': 8.5,
    'voteCount': 1000,
    'isFavorite': false,
    'genres': ['Action', 'Drama'],
    'posterUrl': '/test_poster.jpg',
  };

  static const testMoviesListJson = {
    'data': {
      'movies': [testMovieJson],
      'pagination': {
        'currentPage': 1,
        'maxPage': 10,
        'totalCount': 100
      }
    }
  };

}

void main() {
  // Test data helper - no tests to run
}
