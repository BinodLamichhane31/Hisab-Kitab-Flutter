import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/notification/domain/entity/notification_entity.dart';
import 'package:hisab_kitab/features/notification/domain/repository/notification_repository.dart';
import 'package:hisab_kitab/features/notification/domain/use_case/stream_usecase.dart';

class ListenForNotificationsUsecase
    implements StreamUseCaseWithoutParams<NotificationEntity> {
  final INotificationRepository _repository;

  ListenForNotificationsUsecase({required INotificationRepository repository})
    : _repository = repository;
  @override
  Stream<Either<Failure, NotificationEntity>> call() {
    return _repository.listenForNotifications();
  }
}
