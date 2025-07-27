import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/notification/domain/entity/notification_entity.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;
  const MarkNotificationAsRead(this.notificationId);
  @override
  List<Object> get props => [notificationId];
}

class MarkAllNotificationsAsRead extends NotificationEvent {}

class NotificationReceived extends NotificationEvent {
  final NotificationEntity notification;
  const NotificationReceived(this.notification);
  @override
  List<Object> get props => [notification];
}
