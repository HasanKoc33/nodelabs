import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nodelabs/core/services/localization_service.dart';
import 'package:nodelabs/core/services/storage_service.dart';
import '../../helpers/test_helper.dart';

void main() {
  group('LocalizationService', () {
    late LocalizationService localizationService;
    late MockStorageService mockStorageService;

    setUp(() {
      mockStorageService = MockStorageService();
      localizationService = LocalizationService(mockStorageService);
    });

    group('Initialization', () {
      test('should have correct supported locales', () {
        // arrange & act
        final supportedLocales = LocalizationService.supportedLocales;

        // assert
        expect(supportedLocales, isNotEmpty);
        expect(supportedLocales.length, 2);
        expect(supportedLocales.first, const Locale('tr', 'TR'));
        expect(supportedLocales.last, const Locale('en', 'US'));
      });
    });

    group('Current Locale', () {
      test('should return saved locale from storage', () {
        // arrange
        when(() => mockStorageService.getString(any<String>()))
            .thenReturn('en');
        
        // act
        final currentLocale = localizationService.currentLocale;
        
        // assert
        expect(currentLocale, const Locale('en'));
      });

      test('should return default Turkish locale when no preference is saved', () {
        // arrange
        when(() => mockStorageService.getString(any<String>()))
            .thenReturn(null);
        
        // act
        final currentLocale = localizationService.currentLocale;
        
        // assert
        expect(currentLocale, const Locale('tr', 'TR'));
      });
    });

    group('Set Locale', () {
      test('should save locale preference to storage', () async {
        // arrange
        const newLocale = Locale('en', 'US');
        when(() => mockStorageService.setString(any<String>(), any<String>()))
            .thenAnswer((_) async {});
        
        // act
        await localizationService.setLocale(newLocale);
        
        // assert
        verify(() => mockStorageService.setString(any<String>(), 'en')).called(1);
      });
    });

    group('Locale Support', () {
      test('should correctly identify supported locales', () {
        // arrange & act & assert
        expect(localizationService.isSupported(const Locale('tr', 'TR')), isTrue);
        expect(localizationService.isSupported(const Locale('en', 'US')), isTrue);
        expect(localizationService.isSupported(const Locale('fr', 'FR')), isFalse);
        expect(localizationService.isSupported(const Locale('de', 'DE')), isFalse);
      });
    });
  });
}
