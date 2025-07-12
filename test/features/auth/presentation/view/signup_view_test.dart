import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/features/auth/presentation/view/signup_view.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockSignupViewModel extends MockBloc<SignupEvent, SignupState>
    implements SignupViewModel {}

void main() {
  late MockSignupViewModel mockSignupViewModel;

  Future<void> pumpSignupView(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<SignupViewModel>.value(
        value: mockSignupViewModel,
        child: MaterialApp(home: SignupView()),
      ),
    );
  }

  setUp(() {
    mockSignupViewModel = MockSignupViewModel();
    when(() => mockSignupViewModel.state).thenReturn(SignupState.initial());
  });

  group('SignupView', () {
    testWidgets('renders initial UI elements correctly', (
      WidgetTester tester,
    ) async {
      await pumpSignupView(tester);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Have an account? '), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Create'), findsOneWidget);
    });

    group('Form Validation', () {
      testWidgets(
        'shows required error messages when form is submitted empty',
        (WidgetTester tester) async {
          await pumpSignupView(tester);

          final createButton = find.widgetWithText(ElevatedButton, 'Create');
          await tester.ensureVisible(createButton);
          await tester.tap(createButton);
          await tester.pump();

          expect(find.text('First name is required'), findsOneWidget);
          expect(find.text('Last name is required'), findsOneWidget);
          expect(find.text('Phone number is required.'), findsOneWidget);
          expect(find.text('Email is required'), findsOneWidget);
          expect(find.text('Password is required'), findsOneWidget);
          expect(find.text('Confirm Password is required'), findsOneWidget);
        },
      );

      testWidgets('shows error message for password mismatch', (
        WidgetTester tester,
      ) async {
        await pumpSignupView(tester);

        final passwordField = find.byType(TextFormField).at(4);
        final confirmPasswordField = find.byType(TextFormField).at(5);

        await tester.enterText(passwordField, 'password123');
        await tester.enterText(confirmPasswordField, 'password456');

        final createButton = find.widgetWithText(ElevatedButton, 'Create');
        await tester.ensureVisible(createButton);
        await tester.tap(createButton);
        await tester.pump();

        expect(
          find.text('Password and confirm password must be same.'),
          findsOneWidget,
        );
      });
    });
  });
}
