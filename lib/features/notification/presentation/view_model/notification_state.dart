import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/notification/domain/entity/notification_entity.dart';

enum NotificationStatus { initial, loading, success, error }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final String? errorMessage;

  const NotificationState({
    required this.status,
    required this.notifications,
    required this.unreadCount,
    this.errorMessage,
  });

  factory NotificationState.initial() {
    return const NotificationState(
      status: NotificationStatus.initial,
      notifications: [],
      unreadCount: 0,
      errorMessage: null,
    );
  }

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? notifications,
    int? unreadCount,
    String? errorMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notifications, unreadCount, errorMessage];
}
