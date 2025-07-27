import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/notification/domain/entity/notification_entity.dart';

abstract class INotificationRepository {
  Future<Either<Failure, NotificationDataEntity>> getNotifications();
  Future<Either<Failure, bool>> markAsRead(String notificationId);
  Future<Either<Failure, bool>> markAllAsRead();

  // Real-time stream
  Stream<Either<Failure, NotificationEntity>> listenForNotifications();
  void disconnectListener();
}
