import 'package:flutter_test/flutter_test.dart';
import 'package:nodelabs/data/models/user_model.dart';
import 'package:nodelabs/domain/entities/user.dart';
import '../../helpers/test_data.dart';

void main() {
  group('UserModel', () {
    test('should be a subclass of User entity', () {
      // Assert
      expect(TestData.testUserModel, isA<User>());
    });

    group('fromJson', () {
      test('should return a valid UserModel from JSON', () {
        // Act
        final result = UserModel.fromJson(TestData.testUserJson);

        // Assert
        expect(result, equals(TestData.testUserModel));
      });

      test('should handle null optional fields', () {
        // Arrange
        final jsonWithNulls = {
          'id': '67bc8d58d9ec4d40040b81b6',
          'name': 'Test User',
          'email': 'test@example.com',
          'profileImageUrl': null,
          'favoriteMovies': null,
        };

        // Act
        final result = UserModel.fromJson(jsonWithNulls);

        // Assert
        expect(result.id, '67bc8d58d9ec4d40040b81b6');
        expect(result.name, 'Test User');
        expect(result.email, 'test@example.com');
        expect(result.profileImageUrl, null);
        expect(result.favoriteMovies, null);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = TestData.testUserModel.toJson();

        // Assert
        expect(result, TestData.testUserJson);
      });
    });

    group('fromEntity', () {
      test('should create UserModel from User entity', () {
        // Act
        final result = UserModel.fromEntity(TestData.testUser);

        // Assert
        expect(result.id, TestData.testUser.id);
        expect(result.name, TestData.testUser.name);
        expect(result.email, TestData.testUser.email);
        expect(result.profileImageUrl, TestData.testUser.profileImageUrl);
        expect(result.favoriteMovies, TestData.testUser.favoriteMovies);
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        // Arrange
        const userModel1 = UserModel(
          id: '1',
          name: 'Test',
          email: 'test@test.com',
        );
        const userModel2 = UserModel(
          id: '1',
          name: 'Test',
          email: 'test@test.com',
        );

        // Assert
        expect(userModel1, equals(userModel2));
      });

      test('should not be equal when properties differ', () {
        // Arrange
        const userModel1 = UserModel(
          id: '1',
          name: 'Test',
          email: 'test@test.com',
        );
        const userModel2 = UserModel(
          id: '2',
          name: 'Test',
          email: 'test@test.com',
        );

        // Assert
        expect(userModel1, isNot(equals(userModel2)));
      });
    });
  });
}
