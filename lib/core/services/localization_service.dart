import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';
import 'storage_service.dart';

@lazySingleton
class LocalizationService {
  final StorageService _storageService;
  
  LocalizationService(this._storageService);

  static const List<Locale> supportedLocales = [
    Locale('tr', 'TR'),
    Locale('en', 'US'),
  ];

  Locale get currentLocale {
    final languageCode = _storageService.getString(AppConstants.languageKey);
    if (languageCode != null) {
      return Locale(languageCode);
    }
    return const Locale('tr', 'TR'); // Default to Turkish
  }

  Future<void> setLocale(Locale locale) async {
    await _storageService.setString(AppConstants.languageKey, locale.languageCode);
  }

  bool isSupported(Locale locale) {
    return supportedLocales.any((supportedLocale) => 
        supportedLocale.languageCode == locale.languageCode);
  }
}
