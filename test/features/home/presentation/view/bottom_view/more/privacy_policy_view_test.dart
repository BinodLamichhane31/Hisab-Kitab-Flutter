import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/features/home/presentation/view/bottom_view/more/privacy_policy_view.dart';

void main() {
  group('PrivacyPolicyView', () {
    testWidgets('renders privacy policy view with correct elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const PrivacyPolicyView()));

      // Check if app bar is rendered with correct title
      expect(find.text('Privacy Policy'), findsOneWidget);

      // Check if main heading is displayed
      expect(find.text('Our Commitment to Your Privacy'), findsOneWidget);

      // Check if last updated date is displayed
      expect(find.text('Last Updated: October 26, 2023'), findsOneWidget);

      // Check if all privacy policy sections are displayed
      expect(find.text('1. Information We Collect'), findsOneWidget);
      expect(find.text('2. How We Use Information'), findsOneWidget);
      expect(find.text('3. Data Security'), findsOneWidget);
      expect(find.text('4. Changes to This Policy'), findsOneWidget);

      // Check if some key content is present
      expect(
        find.textContaining(
          'We collect information to provide better services',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('We work hard to protect Hisab Kitab'),
        findsOneWidget,
      );
    });
  });
}
