import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/features/home/presentation/view/bottom_view/more/help_and_support_view.dart';

void main() {
  group('HelpAndSupportView', () {
    testWidgets('renders help and support view with correct elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const HelpAndSupportView()));

      // Check if app bar is rendered with correct title
      expect(find.text('Help & Support'), findsOneWidget);

      // Check if FAQ section is rendered
      expect(find.text('Frequently Asked Questions'), findsOneWidget);

      // Check if FAQ items are displayed
      expect(find.text('How do I add a new customer?'), findsOneWidget);
      expect(
        find.text('Can I use this app on multiple devices?'),
        findsOneWidget,
      );
      expect(find.text('How is my data backed up?'), findsOneWidget);

      // Check if contact section is rendered
      expect(find.text('Contact Us'), findsOneWidget);

      // Check if contact tiles are displayed
      expect(find.text('Email Support'), findsOneWidget);
      expect(find.text('support@hisabkitab.app'), findsOneWidget);
      expect(find.text('Call Us'), findsOneWidget);
      expect(find.text('+977 9841XXXXXX'), findsOneWidget);

      // Check if icons are present
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.phone_outlined), findsOneWidget);

      // Check if expansion tiles are present
      expect(find.byType(ExpansionTile), findsNWidgets(3)); // 3 FAQ items
    });
  });
}
