import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/features/home/presentation/view/bottom_view/more/subscription_view.dart';

void main() {
  group('SubscriptionView', () {
    testWidgets('displays all pro features with check icons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const SubscriptionView()));

      // Verify all feature items are present with check icons
      final featureItems = [
        'Unlimited Shops',
        'AI Hisab Assistant',
        'Priority Support',
        'Advanced Analytics',
        'Custom Reports',
      ];

      for (final feature in featureItems) {
        expect(find.text(feature), findsOneWidget);
      }

      // Verify check icons are present for each feature
      expect(find.byIcon(Icons.check_circle), findsNWidgets(5));
    });

    testWidgets('displays price information correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const SubscriptionView()));

      // Check price display
      expect(find.text('₹1000'), findsOneWidget);
      expect(find.text('/ year'), findsOneWidget);
    });

    testWidgets('has visit website button', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const SubscriptionView()));

      // Check if visit website button is present
      expect(find.text('Visit Website'), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    });

    testWidgets('has proper card layout', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const SubscriptionView()));

      // Check if cards are present
      expect(find.byType(Card), findsNWidgets(2)); // Two main cards
    });
  });
}
