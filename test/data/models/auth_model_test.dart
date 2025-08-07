import 'package:flutter_test/flutter_test.dart';
import 'package:nodelabs/data/models/auth_model.dart';
import 'package:nodelabs/data/models/user_model.dart';
import '../../helpers/test_data.dart';

void main() {
  group('LoginRequest', () {
    test('should create LoginRequest with required fields', () {
      // Arrange & Act
      const loginRequest = LoginRequest(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(loginRequest.email, 'test@example.com');
      expect(loginRequest.password, 'password123');
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = TestData.testLoginRequest.toJson();

        // Assert
        expect(result, {
          'email': 'test@example.com',
          'password': 'password123',
        });
      });
    });

    group('fromJson', () {
      test('should return a valid LoginRequest from JSON', () {
        // Arrange
        final json = {
          'email': 'test@example.com',
          'password': 'password123',
        };

        // Act
        final result = LoginRequest.fromJson(json);

        // Assert
        expect(result.email, 'test@example.com');
        expect(result.password, 'password123');
      });
    });
  });

  group('RegisterRequest', () {
    test('should create RegisterRequest with required fields', () {
      // Arrange & Act
      const registerRequest = RegisterRequest(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(registerRequest.name, 'Test User');
      expect(registerRequest.email, 'test@example.com');
      expect(registerRequest.password, 'password123');
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = TestData.testRegisterRequest.toJson();

        // Assert
        expect(result, {
          'name': 'Test User',
          'email': 'test@example.com',
          'password': 'password123',
        });
      });
    });

    group('fromJson', () {
      test('should return a valid RegisterRequest from JSON', () {
        // Arrange
        final json = {
          'name': 'Test User',
          'email': 'test@example.com',
          'password': 'password123',
        };

        // Act
        final result = RegisterRequest.fromJson(json);

        // Assert
        expect(result.name, 'Test User');
        expect(result.email, 'test@example.com');
        expect(result.password, 'password123');
      });
    });
  });

  group('AuthResponse', () {
    group('fromJson', () {
      test('should return a valid AuthResponse from JSON', () {
        // Act
        final result = AuthResponse.fromJson(TestData.testAuthResponseJson);

        // Assert
        expect(result.token, 'test_token_123');
        expect(result.user.id, '67bc8d58d9ec4d40040b81b6');
        expect(result.user.name, 'Test User');
        expect(result.user.email, 'test@example.com');
      });

      test('should throw when data field is missing', () {
        // Arrange
        final invalidJson = {
          'token': 'test_token_123',
          'user': TestData.testUserJson,
        };

        // Act & Assert
        expect(
          () => AuthResponse.fromJson(invalidJson),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw when token is missing from data', () {
        // Arrange
        final invalidJson = {
          'data': {
            'id': '67bc8d58d9ec4d40040b81b6',
            'name': 'Test User',
            'email': 'test@example.com',
            // token is missing
          }
        };

        // Act & Assert
        expect(
          () => AuthResponse.fromJson(invalidJson),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = TestData.testAuthResponse.toJson();

        // Assert
        expect(result['token'], 'test_token_123');
        expect(result['user'], isA<UserModel>());
        expect(result['user'].toJson(), isA<Map<String, dynamic>>());
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        // Arrange
        const authResponse1 = AuthResponse(
          token: 'token123',
          user: TestData.testUserModel,
        );
        const authResponse2 = AuthResponse(
          token: 'token123',
          user: TestData.testUserModel,
        );

        // Assert
        expect(authResponse1.token, equals(authResponse2.token));
        expect(authResponse1.user, equals(authResponse2.user));
      });
    });
  });
}
