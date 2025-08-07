import 'dart:convert';

void main() {
  // Test JSON parsing with actual API response
  final jsonResponse = '''
  {
    "response": {"code": 200, "message": ""},
    "data": {
      "movies": [
        {
          "_id": "67bc8502e03a0ef366d5c671",
          "id": "67bc8502e03a0ef366d5c671",
          "Title": "Interstellar",
          "Plot": "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
          "Poster": "http://ia.media-imdb.com/images/M/MV5BMjIxNTU4MzY4MF5BMl5BanBnXkFtZTgwMzM4ODI3MjE@..jpg",
          "isFavorite": false
        }
      ],
      "pagination": {
        "totalCount": 16,
        "perPage": 5,
        "maxPage": 4,
        "currentPage": 1
      }
    }
  }
  ''';
  
  try {
    final parsed = json.decode(jsonResponse);
    final data = parsed['data'];
    final movies = data['movies'] as List;
    final pagination = data['pagination'];
    
    print('Movies count: ${movies.length}');
    print('Total pages: ${pagination['maxPage']}');
    print('Current page: ${pagination['currentPage']}');
    
    if (movies.isNotEmpty) {
      final movie = movies.first;
      print('\nFirst movie:');
      print('ID: ${movie['id']}');
      print('Title: ${movie['Title']}');
      print('Plot: ${movie['Plot']}');
      print('Poster: ${movie['Poster']}');
      print('Is Favorite: ${movie['isFavorite']}');
    }
    
    print('\n✅ JSON parsing successful!');
    
  } catch (e) {
    print('❌ Error parsing JSON: $e');
  }
}
