import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nodelabs/core/di/injection.dart';
import 'package:nodelabs/core/services/navigation_service.dart';
import 'package:nodelabs/firebase_options.dart';
import 'package:nodelabs/presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on Exception catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // Initialize dependency injection
  await configureDependencies();

  // Initialize navigation service
  getIt<NavigationService>().initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('tr', 'TR'),
      child: const App(),
    ),
  );
}
