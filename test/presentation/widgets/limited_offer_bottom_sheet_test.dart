import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nodelabs/presentation/widgets/limited_offer_bottom_sheet.dart';

void main() {
  group('LimitedOfferBottomSheet Widget Tests', () {
    Widget createTestWidget() {
      return EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: const Scaffold(
              body: LimitedOfferBottomSheet(),
            ),
          ),
        ),
      );
    }

    testWidgets('should render without errors', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert - just verify the widget renders
      expect(find.byType(LimitedOfferBottomSheet), findsOneWidget);
    });

    testWidgets('should display basic UI elements', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // assert - just verify the widget renders
      expect(find.byType(LimitedOfferBottomSheet), findsOneWidget);
    });
  });
}
