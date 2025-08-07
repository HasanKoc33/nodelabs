import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:mocktail/mocktail.dart';
import '../../../helpers/test_helper.dart'; // Use central mock/fake setup
import 'package:nodelabs/presentation/bloc/auth/auth_bloc.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_state.dart';
import 'package:nodelabs/presentation/screens/auth/login_screen.dart';



void main() {
  group('LoginScreen Simple Tests', () {
    late MockAuthBloc mockAuthBloc;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
      // No fallback needed for AuthInitial since it has no parameters
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
    });

    Widget createTestWidget() {
      return EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
        path: 'assets/translations', // Bu path gerçek translation dosyalarınızın yolu
        fallbackLocale: const Locale('en', 'US'),
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: BlocProvider<AuthBloc>(
              create: (_) => mockAuthBloc,
              child: const LoginScreen(),
            ),
          ),
        ),
      );
    }

    testWidgets('should render LoginScreen without crashing', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('should show loading indicator when auth state is loading', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());
      
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should contain basic UI elements', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle(); // EasyLocalization için settle kullanıyoruz

      // Assert - Look for basic elements that should exist
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(TextFormField), findsAtLeastNWidgets(1)); // Email and password fields
    });

    testWidgets('should find localized text elements (flexible)', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Daha esnek text arama
      final textWidgets = find.byType(Text);
      expect(textWidgets, findsAtLeastNWidgets(1));
      // Optionally print found texts for debug
      // for (int i = 0; i < textWidgets.evaluate().length; i++) {
      //   final textWidget = tester.widget<Text>(textWidgets.at(i));
      //   print('Text $i: "${textWidget.data}"');
      // }
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Just verify the screen renders successfully
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
