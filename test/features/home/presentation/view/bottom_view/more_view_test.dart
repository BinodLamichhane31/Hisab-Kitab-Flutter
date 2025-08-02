import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/home/presentation/view/bottom_view/more_view.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeViewModel extends Mock implements HomeViewModel {}

class MockSessionCubit extends MockBloc<SessionCubit, SessionState>
    implements SessionCubit {}

void main() {
  group('MoreView', () {
    late MockHomeViewModel mockHomeViewModel;
    late MockSessionCubit mockSessionCubit;

    setUp(() {
      mockHomeViewModel = MockHomeViewModel();
      mockSessionCubit = MockSessionCubit();
    });

    testWidgets('renders more view with correct sections', (
      WidgetTester tester,
    ) async {
      when(() => mockSessionCubit.state).thenReturn(SessionState.initial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SessionCubit>.value(
            value: mockSessionCubit,
            child: BlocProvider<HomeViewModel>.value(
              value: mockHomeViewModel,
              child: const Scaffold(body: MoreView()),
            ),
          ),
        ),
      );

      // Check if section headers are displayed
      expect(find.text('ACCOUNT & MANAGEMENT'), findsOneWidget);
      expect(find.text('REPORTS & ACTIVITY'), findsOneWidget);
      expect(find.text('GENERAL'), findsOneWidget);

      // Check if main option items are displayed
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Manage Shop'), findsOneWidget);
      expect(find.text('Sales'), findsOneWidget);
      expect(find.text('Purchase'), findsOneWidget);
      expect(find.text('Transactions'), findsOneWidget);
      expect(find.text('Subscription'), findsOneWidget);
      expect(find.text('Help and Support'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });
  });
}
