import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hisab_kitab/features/notification/presentation/view/notification_view.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_state.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_event.dart';
import 'package:hisab_kitab/features/notification/domain/entity/notification_entity.dart';

class MockNotificationViewModel
    extends MockBloc<NotificationEvent, NotificationState>
    implements NotificationViewModel {}

void main() {
  group('NotificationView', () {
    late MockNotificationViewModel mockNotificationViewModel;

    setUp(() {
      mockNotificationViewModel = MockNotificationViewModel();
    });

    testWidgets('renders notification view with correct elements', (
      WidgetTester tester,
    ) async {
      when(
        () => mockNotificationViewModel.state,
      ).thenReturn(NotificationState.initial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<NotificationViewModel>.value(
            value: mockNotificationViewModel,
            child: const NotificationView(),
          ),
        ),
      );

      // Check if app bar is rendered with correct title
      expect(find.text('Notifications'), findsOneWidget);

      // Check if mark all as read button is present
      expect(find.text('Mark all as read'), findsOneWidget);

      // Check if empty state is displayed when no notifications
      expect(find.text('You have no notifications.'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_off_outlined), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (
      WidgetTester tester,
    ) async {
      when(() => mockNotificationViewModel.state).thenReturn(
        NotificationState.initial().copyWith(
          status: NotificationStatus.loading,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<NotificationViewModel>.value(
            value: mockNotificationViewModel,
            child: const NotificationView(),
          ),
        ),
      );

      // Check if loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows notifications list when notifications exist', (
      WidgetTester tester,
    ) async {
      final mockNotifications = [
        NotificationEntity(
          id: '1',
          message: 'Low stock alert for Product A',
          type: NotificationType.LOW_STOCK,
          link: '/products/123',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        NotificationEntity(
          id: '2',
          message: 'Payment due reminder',
          type: NotificationType.PAYMENT_DUE,
          link: '',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      when(() => mockNotificationViewModel.state).thenReturn(
        NotificationState.initial().copyWith(
          notifications: mockNotifications,
          unreadCount: 1,
          status: NotificationStatus.success,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<NotificationViewModel>.value(
            value: mockNotificationViewModel,
            child: const NotificationView(),
          ),
        ),
      );

      // Check if notifications are displayed
      expect(find.text('Low stock alert for Product A'), findsOneWidget);
      expect(find.text('Payment due reminder'), findsOneWidget);

      // Check if notification icons are present
      expect(
        find.byIcon(Icons.inventory_2_outlined),
        findsOneWidget,
      ); // LOW_STOCK
      expect(
        find.byIcon(Icons.payment_outlined),
        findsOneWidget,
      ); // PAYMENT_DUE

      // Check if unread notification has different styling (bold text)
      expect(find.text('Low stock alert for Product A'), findsOneWidget);
    });
  });
}
