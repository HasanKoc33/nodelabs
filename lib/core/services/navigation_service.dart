import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:nodelabs/presentation/screens/auth/login_screen.dart';
import 'package:nodelabs/presentation/screens/auth/register_screen.dart';
import 'package:nodelabs/presentation/screens/auth/upload_photo_screen.dart';
import 'package:nodelabs/presentation/screens/home/home_screen.dart';
import 'package:nodelabs/presentation/screens/main/main_navigation_wrapper.dart';
import 'package:nodelabs/presentation/screens/profile/profile_screen.dart';
import 'package:nodelabs/presentation/screens/splash/splash_screen.dart';

/// Navigation service that manages app routing using GoRouter.
@lazySingleton
class NavigationService {
  late final GoRouter _router;

  /// Provides the GoRouter instance for navigation.
  GoRouter get router => _router;

  /// Initializes the navigation service with predefined routes.
  void initialize() {
    _router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/upload-photo',
          name: 'upload-photo',
          builder: (context, state) => const UploadPhotoScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => MainNavigationWrapper(child: child),
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }

  void goToLogin() => _router.goNamed('login');
  void goToRegister() => _router.goNamed('register');
  void goToUploadPhoto() => _router.pushNamed('upload-photo');
  void goToHome() => _router.goNamed('home');
  void goToProfile() => _router.goNamed('profile');
  void goBack() => _router.pop();
  
  /// Navigate to upload photo using root navigator (bypasses bottom nav)
  void goToUploadPhotoFullScreen() {
    // Clear the navigation stack and go to upload photo
    _router.push('/upload-photo');
  }
  
  /// Navigate with root context (for modals, full screen pages)
  void pushFullScreen(String path) {
    _router.push(path);
  }
  
  /// Force navigation outside shell route
  void goToUploadPhotoBypassShell() {
    // This ensures we completely bypass the shell route
    _router.pushReplacement('/upload-photo');
  }
}
