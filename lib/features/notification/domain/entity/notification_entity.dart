import 'package:equatable/equatable.dart';

enum NotificationType { LOW_STOCK, COLLECTION_OVERDUE, PAYMENT_DUE, GENERAL }

class NotificationEntity extends Equatable {
  final String id;
  final String message;
  final NotificationType type;
  final String link;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.message,
    required this.type,
    required this.link,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, message, type, link, isRead, createdAt];
}

class NotificationDataEntity extends Equatable {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationDataEntity({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}
