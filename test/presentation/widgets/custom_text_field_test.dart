import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nodelabs/presentation/widgets/custom_text_field.dart';

void main() {
  group('CustomTextField Widget Tests', () {
    testWidgets('should render without errors', (WidgetTester tester) async {
      // arrange
      final controller = TextEditingController();
      
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Email',
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(TextFormField), findsOneWidget);
      
      // cleanup
      controller.dispose();
    });

    testWidgets('should display hint text', (WidgetTester tester) async {
      // arrange
      final controller = TextEditingController();
      
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Test Hint',
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Test Hint'), findsOneWidget);
      
      // cleanup
      controller.dispose();
    });

    testWidgets('should render with prefix icon', (WidgetTester tester) async {
      // arrange
      final controller = TextEditingController();
      const prefixIcon = Icon(Icons.email);
      
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Email',
              prefixIcon: prefixIcon,
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(TextFormField), findsOneWidget);
      
      // cleanup
      controller.dispose();
    });

    testWidgets('should render with suffix icon', (WidgetTester tester) async {
      // arrange
      final controller = TextEditingController();
      const suffixIcon = Icon(Icons.visibility);
      
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Password',
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(TextFormField), findsOneWidget);
      
      // cleanup
      controller.dispose();
    });

    testWidgets('should render with obscure text', (WidgetTester tester) async {
      // arrange
      final controller = TextEditingController();
      
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Password',
              obscureText: true,
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(TextFormField), findsOneWidget);
      
      // cleanup
      controller.dispose();
    });

    testWidgets('should render without obscure text', (WidgetTester tester) async {
      // arrange
      final controller = TextEditingController();
      
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Email',
              obscureText: false,
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(TextFormField), findsOneWidget);
      
      // cleanup
      controller.dispose();
    });

    testWidgets('should render with provided controller', (WidgetTester tester) async {
      // arrange
      final controller = TextEditingController(text: 'initial text');

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              hintText: 'Email',
              controller: controller,
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(TextFormField), findsOneWidget);
      
      // cleanup
      controller.dispose();
    });

    testWidgets('should render with correct styling', (WidgetTester tester) async {
      // arrange
      final controller = TextEditingController();
      
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Email',
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(TextFormField), findsOneWidget);
      
      // cleanup
      controller.dispose();
    });
  });
}
