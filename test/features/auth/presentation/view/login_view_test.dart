import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/features/auth/presentation/view/login_view.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockLoginViewModel extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}

void main() {
  late MockLoginViewModel mockLoginViewModel;

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());
  });

  Future<void> pumpLoginView(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<LoginViewModel>.value(
        value: mockLoginViewModel,
        child: MaterialApp(home: LoginView()),
      ),
    );
  }

  group('LoginView', () {
    testWidgets('renders welcome text and login button correctly', (
      WidgetTester tester,
    ) async {
      await pumpLoginView(tester);

      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Login to your account'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    group('Form Validation', () {
      testWidgets(
        'shows required error messages when email and password are empty',
        (WidgetTester tester) async {
          // Arrange
          await pumpLoginView(tester);

          // Act
          await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
          await tester.pump();
          // Assert
          expect(find.text('Email is required'), findsOneWidget);
          expect(find.text('Password is required'), findsOneWidget);
        },
      );

      testWidgets('shows error message for invalid email format', (
        WidgetTester tester,
      ) async {
        // Arrange
        await pumpLoginView(tester);
        final emailField = find.byType(TextFormField).first;

        // Act
        await tester.enterText(emailField, 'invalid-email');
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
        await tester.pump();

        // Assert
        expect(find.text('Enter a valid email'), findsOneWidget);
      });

      testWidgets('shows error message for password less than 6 characters', (
        WidgetTester tester,
      ) async {
        // Arrange
        await pumpLoginView(tester);
        final emailField = find.byType(TextFormField).first;
        final passwordField = find.byType(TextFormField).last;

        // Act
        await tester.enterText(emailField, 'binod@gmail.com');
        await tester.enterText(passwordField, 'binod');
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
        await tester.pump();

        // Assert
        expect(
          find.text('Password must be at least 6 characters'),
          findsOneWidget,
        );
      });
    });
    testWidgets('Login success', (tester) async {
      when(() => mockLoginViewModel.state).thenReturn(
        LoginState(isLoading: true, isSuccess: true, isPasswordVisible: false),
      );

      await pumpLoginView(tester);

      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'binod@gmail.com');
      await tester.enterText(find.byType(TextField).at(1), 'binod123');

      await tester.tap(find.byType(ElevatedButton).first);

      await tester.pumpAndSettle();

      expect(mockLoginViewModel.state.isSuccess, true);
    });
  });
}
