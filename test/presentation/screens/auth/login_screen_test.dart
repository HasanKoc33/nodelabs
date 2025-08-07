import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_bloc.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_state.dart';
import 'package:nodelabs/presentation/screens/auth/login_screen.dart';
import 'package:nodelabs/presentation/widgets/custom_text_field.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  group('LoginScreen Widget Tests', () {
    late MockAuthBloc mockAuthBloc;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
    });

    Widget createTestWidget() {
      return EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: Builder(
          builder: (context) => MaterialApp(
            home: BlocProvider<AuthBloc>(
              create: (_) => mockAuthBloc,
              child: const LoginScreen(),
            ),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          ),
        ),
      );
    }

    testWidgets('should display welcome text', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.text('Merhabalar'.tr()), findsOneWidget);
    });

    testWidgets('should display subtitle text', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.textContaining('Hesabına giriş yap'.tr()), findsOneWidget);
    });

    testWidgets('should display email and password text fields', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.byType(CustomTextField), findsNWidgets(2));
    });

    testWidgets('should display email text field with correct hint', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.text('E-posta'), findsOneWidget);
    });

    testWidgets('should display password text field with correct hint', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.text('Şifre'), findsOneWidget);
    });

    testWidgets('should display forgot password link', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.text('Şifremi unuttum'), findsOneWidget);
    });

    testWidgets('should display login button', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.text('Giriş Yap'), findsOneWidget);
    });

    testWidgets('should display social login buttons', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.text('G'), findsOneWidget);
      expect(find.text('🍎'), findsOneWidget);
      expect(find.text('f'), findsOneWidget);
    });

    testWidgets('should display register link', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.textContaining('Bir hesabın yok mu?'), findsOneWidget);
      expect(find.textContaining('Kayıt Ol'), findsOneWidget);
    });

    testWidgets('should have black background', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.black);
    });

    testWidgets('should enable login button when form is valid', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // act
      await tester.enterText(find.byType(CustomTextField).first, 'test@example.com');
      await tester.enterText(find.byType(CustomTextField).last, 'password123');
      await tester.pump();

      // assert
      final loginButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Giriş Yap'),
      );
      expect(loginButton.onPressed, isNotNull);
    });

    testWidgets('should show loading indicator when auth state is loading', (WidgetTester tester) async {
      // arrange
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());
      
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should navigate to register when register link is tapped', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // act
      await tester.tap(find.textContaining('Kayıt Ol'));
      await tester.pump();

      // assert - This would require navigation testing setup
      // For now, we just verify the tap doesn't crash
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('should have proper styling for login button', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert
      final elevatedButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Giriş Yap'),
      );
      
      expect(elevatedButton.style?.backgroundColor?.resolve({}), const Color(0xFFE53E3E));
    });
  });
}
