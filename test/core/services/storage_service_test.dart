import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nodelabs/core/services/storage_service.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('StorageService', () {
    late StorageService storageService;

    setUp(() {
      storageService = StorageService();
    });

    group('SharedPreferences operations', () {
      setUp(() async {
        // Initialize SharedPreferences with empty values
        SharedPreferences.setMockInitialValues({});
        await storageService.init();
      });

      group('String operations', () {
        test('should store and retrieve string values', () async {
          // Arrange
          const key = 'test_key';
          const value = 'test_value';

          // Act
          await storageService.setString(key, value);
          final result = storageService.getString(key);

          // Assert
          expect(result, equals(value));
        });

        test('should return null for non-existent string key', () {
          // Act
          final result = storageService.getString('non_existent_key');

          // Assert
          expect(result, isNull);
        });
      });

      group('Boolean operations', () {
        test('should store and retrieve boolean values', () async {
          // Arrange
          const key = 'test_bool_key';
          const value = true;

          // Act
          await storageService.setBool(key, value);
          final result = storageService.getBool(key);

          // Assert
          expect(result, equals(value));
        });

        test('should return null for non-existent boolean key', () {
          // Act
          final result = storageService.getBool('non_existent_key');

          // Assert
          expect(result, isNull);
        });
      });

      group('Integer operations', () {
        test('should store and retrieve integer values', () async {
          // Arrange
          const key = 'test_int_key';
          const value = 42;

          // Act
          await storageService.setInt(key, value);
          final result = storageService.getInt(key);

          // Assert
          expect(result, equals(value));
        });

        test('should return null for non-existent integer key', () {
          // Act
          final result = storageService.getInt('non_existent_key');

          // Assert
          expect(result, isNull);
        });
      });

      group('Object operations', () {
        test('should store and retrieve object values', () async {
          // Arrange
          const key = 'test_object_key';
          const value = {
            'name': 'John Doe',
            'age': 30,
            'isActive': true,
          };

          // Act
          await storageService.setObject(key, value);
          final result = storageService.getObject(key);

          // Assert
          expect(result, equals(value));
        });

        test('should return null for non-existent object key', () {
          // Act
          final result = storageService.getObject('non_existent_key');

          // Assert
          expect(result, isNull);
        });

        test('should handle complex nested objects', () async {
          // Arrange
          const key = 'test_complex_object';
          const value = {
            'user': {
              'id': '123',
              'profile': {
                'name': 'John',
                'preferences': ['dark_mode', 'notifications'],
              },
            },
            'settings': {
              'language': 'en',
              'theme': 'dark',
            },
          };

          // Act
          await storageService.setObject(key, value);
          final result = storageService.getObject(key);

          // Assert
          expect(result, equals(value));
        });
      });

      group('Remove operations', () {
        test('should remove specific key', () async {
          // Arrange
          const key = 'test_remove_key';
          const value = 'test_value';
          await storageService.setString(key, value);

          // Act
          await storageService.remove(key);
          final result = storageService.getString(key);

          // Assert
          expect(result, isNull);
        });

        test('should clear all preferences', () async {
          // Arrange
          await storageService.setString('key1', 'value1');
          await storageService.setString('key2', 'value2');
          await storageService.setBool('key3', true);

          // Act
          await storageService.clear();

          // Assert
          expect(storageService.getString('key1'), isNull);
          expect(storageService.getString('key2'), isNull);
          expect(storageService.getBool('key3'), isNull);
        });
      });
    });

    group('Error handling', () {
      setUp(() async {
        // Initialize SharedPreferences for error handling tests
        SharedPreferences.setMockInitialValues({});
        await storageService.init();
      });

      test('should handle JSON encoding errors gracefully', () async {
        // Arrange
        const key = 'test_invalid_object';
        // Create an object that can't be JSON encoded (contains circular reference)
        final invalidObject = <String, dynamic>{};
        invalidObject['self'] = invalidObject;

        // Act & Assert
        expect(
          () async => await storageService.setObject(key, invalidObject),
          throwsA(isA<JsonUnsupportedObjectError>()),
        );
      });
    });
  });
}
