import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/constants/app_assets.dart';
import 'package:nodelabs/core/di/injection.dart';
import 'package:nodelabs/core/services/navigation_service.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_bloc.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_state.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_event.dart';

/// SplashScreen is the initial screen displayed when the app starts.
class SplashScreen extends StatefulWidget {
  /// Creates a new instance of SplashScreen.
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger auth check immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthCheckRequested());
    });
    
    // Fallback timeout - if auth check takes too long, go to login
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        print('SplashScreen: Timeout reached, navigating to login');
        getIt<NavigationService>().goToLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print('SplashScreen: AuthBloc state changed: $state');
        if (state is AuthAuthenticated) {
          getIt<NavigationService>().goToHome();
        } else if (state is AuthUnauthenticated) {
          getIt<NavigationService>().goToLogin();
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppAssets.splashImage.value, fit: BoxFit.cover),
            // Loading indicator - alt orta
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  strokeWidth: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
