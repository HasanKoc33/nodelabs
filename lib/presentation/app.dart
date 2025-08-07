import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/di/injection.dart';
import 'package:nodelabs/core/services/navigation_service.dart';
import 'package:nodelabs/core/theme/app_theme.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_bloc.dart';
import 'package:nodelabs/presentation/bloc/movies/movies_bloc.dart';
import 'package:nodelabs/presentation/bloc/profile/profile_bloc.dart';

/// Main application widget that initializes the blocs and
/// sets up the app's theme and routing.
class App extends StatelessWidget {
  /// Creates an instance of [App].
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(_initializeBlocs()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error initializing app: ${snapshot.error}'),
              ),
            ),
          );
        }

        final blocs = Map<String, dynamic>.from(snapshot.data!);

        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(
              value: blocs['authBloc'] as AuthBloc,
            ),
            BlocProvider<MoviesBloc>.value(
              value: blocs['moviesBloc'] as MoviesBloc,
            ),
            BlocProvider<ProfileBloc>.value(
              value: blocs['profileBloc'] as ProfileBloc,
            ),
          ],
          child: MaterialApp.router(
            title: 'app.title'.tr(),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            // themeMode: getIt<ThemeService>().themeMode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerConfig: getIt<NavigationService>().router,
          ),
        );
      },
    );
  }

  Map<String, dynamic> _initializeBlocs() {
    final authBloc = getIt<AuthBloc>();
    final moviesBloc = getIt<MoviesBloc>();
    final profileBloc = getIt<ProfileBloc>();
    return {
      'authBloc': authBloc,
      'moviesBloc': moviesBloc,
      'profileBloc': profileBloc,
    };
  }
}
