import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:nodelabs/core/services/navigation_service.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('NavigationService Tests', () {
    late NavigationService navigationService;
    late MockGoRouter mockRouter;

    setUp(() {
      mockRouter = MockGoRouter();
      navigationService = NavigationService();
      // Note: In real implementation, you'd need to inject the router
    });

    group('Navigation Methods', () {
      test('should call goToLogin', () {
        expect(() => navigationService.goToLogin(), returnsNormally);
        expect(() => navigationService.goToRegister(), returnsNormally);
        expect(() => navigationService.goToHome(), returnsNormally);
        expect(() => navigationService.goToProfile(), returnsNormally);
        expect(() => navigationService.goToUploadPhoto(), returnsNormally);
      });

      test('should have back navigation', () {
        // arrange & act & assert
        expect(() => navigationService.goBack(), returnsNormally);
      });
    });

    group('Full Screen Navigation', () {
      test('should navigate full screen', () {
        // arrange & act & assert
        expect(() => navigationService.goToUploadPhotoFullScreen(), returnsNormally);
        expect(() => navigationService.pushFullScreen('/upload-photo'), returnsNormally);
        expect(() => navigationService.goToUploadPhotoBypassShell(), returnsNormally);
      });
    });
  });
}
