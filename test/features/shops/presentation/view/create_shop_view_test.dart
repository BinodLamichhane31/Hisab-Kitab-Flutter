import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hisab_kitab/features/shops/presentation/view/create_shop_view.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_view_model.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_state.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_event.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';

class MockShopViewModel extends MockBloc<ShopEvent, ShopState>
    implements ShopViewModel {}

class MockSessionCubit extends MockBloc<SessionCubit, SessionState>
    implements SessionCubit {}

void main() {
  group('CreateShopView', () {
    late MockShopViewModel mockShopViewModel;
    late MockSessionCubit mockSessionCubit;

    setUp(() {
      mockShopViewModel = MockShopViewModel();
      mockSessionCubit = MockSessionCubit();
    });

    testWidgets('renders create shop view with correct elements', (
      WidgetTester tester,
    ) async {
      when(() => mockShopViewModel.state).thenReturn(const ShopState.initial());
      when(() => mockSessionCubit.state).thenReturn(SessionState.initial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ShopViewModel>.value(
            value: mockShopViewModel,
            child: BlocProvider<SessionCubit>.value(
              value: mockSessionCubit,
              child: const CreateShopView(token: 'test-token'),
            ),
          ),
        ),
      );

      // Check if app bar is rendered with correct title
      expect(find.text('Create Your First Shop'), findsOneWidget);

      // Check if form fields are present
      expect(
        find.byType(TextFormField),
        findsNWidgets(3),
      ); // Shop name, address, contact

      // Check if submit button is present
      expect(find.text('Create and Continue'), findsOneWidget);

      // Check if form is present
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('shows form validation error for empty shop name', (
      WidgetTester tester,
    ) async {
      when(() => mockShopViewModel.state).thenReturn(const ShopState.initial());
      when(() => mockSessionCubit.state).thenReturn(SessionState.initial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ShopViewModel>.value(
            value: mockShopViewModel,
            child: BlocProvider<SessionCubit>.value(
              value: mockSessionCubit,
              child: const CreateShopView(token: 'test-token'),
            ),
          ),
        ),
      );

      // Find and tap the submit button
      final submitButton = find.text('Create and Continue');
      await tester.tap(submitButton);
      await tester.pump();

      // Should show validation error for shop name
      expect(find.text('Shop name is required'), findsOneWidget);
    });
  });
}
