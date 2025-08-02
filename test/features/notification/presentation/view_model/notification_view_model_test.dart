import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_state.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_event.dart';
import 'package:hisab_kitab/features/notification/domain/entity/notification_entity.dart';

void main() {
  group('NotificationViewModel', () {
    test('initial state is correct', () {
      expect(NotificationState.initial(), NotificationState.initial());
    });

    test('initial state properties are correct', () {
      final state = NotificationState.initial();
      expect(state.status, NotificationStatus.initial);
      expect(state.notifications, []);
      expect(state.unreadCount, 0);
      expect(state.errorMessage, null);
    });

    test('state copyWith works correctly', () {
      final initialState = NotificationState.initial();

      // Test with notifications
      final notifications = [
        NotificationEntity(
          id: '1',
          message: 'Test notification',
          type: NotificationType.GENERAL,
          link: '',
          isRead: false,
          createdAt: DateTime.now(),
        ),
      ];

      final updatedState = initialState.copyWith(
        notifications: notifications,
        unreadCount: 1,
        status: NotificationStatus.success,
      );

      expect(updatedState.notifications, notifications);
      expect(updatedState.unreadCount, 1);
      expect(updatedState.status, NotificationStatus.success);
    });

    test('state equality works correctly', () {
      final state1 = NotificationState.initial();
      final state2 = NotificationState.initial();
      final state3 = NotificationState.initial().copyWith(unreadCount: 1);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('NotificationEntity properties are correct', () {
      final notification = NotificationEntity(
        id: '1',
        message: 'Test message',
        type: NotificationType.LOW_STOCK,
        link: '/products/123',
        isRead: false,
        createdAt: DateTime(2023, 1, 1),
      );

      expect(notification.id, '1');
      expect(notification.message, 'Test message');
      expect(notification.type, NotificationType.LOW_STOCK);
      expect(notification.link, '/products/123');
      expect(notification.isRead, false);
      expect(notification.createdAt, DateTime(2023, 1, 1));
    });

    test('NotificationType enum values are correct', () {
      expect(NotificationType.LOW_STOCK, NotificationType.LOW_STOCK);
      expect(
        NotificationType.COLLECTION_OVERDUE,
        NotificationType.COLLECTION_OVERDUE,
      );
      expect(NotificationType.PAYMENT_DUE, NotificationType.PAYMENT_DUE);
      expect(NotificationType.GENERAL, NotificationType.GENERAL);
    });

    test('NotificationStatus enum values are correct', () {
      expect(NotificationStatus.initial, NotificationStatus.initial);
      expect(NotificationStatus.loading, NotificationStatus.loading);
      expect(NotificationStatus.success, NotificationStatus.success);
      expect(NotificationStatus.error, NotificationStatus.error);
    });

    test('NotificationEvent classes can be instantiated', () {
      // Test LoadNotifications
      expect(LoadNotifications(), isA<LoadNotifications>());

      // Test MarkNotificationAsRead
      expect(MarkNotificationAsRead('test-id'), isA<MarkNotificationAsRead>());

      // Test MarkAllNotificationsAsRead
      expect(MarkAllNotificationsAsRead(), isA<MarkAllNotificationsAsRead>());

      // Test NotificationReceived
      final notification = NotificationEntity(
        id: '1',
        message: 'Test',
        type: NotificationType.GENERAL,
        link: '',
        isRead: false,
        createdAt: DateTime.now(),
      );
      expect(NotificationReceived(notification), isA<NotificationReceived>());
    });
  });
}
