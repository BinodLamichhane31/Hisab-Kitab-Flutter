import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/notification/domain/entity/notification_entity.dart';
import 'package:hisab_kitab/features/notification/domain/repository/notification_repository.dart';

class GetNotificationsUsecase
    implements UseCaseWithoutParams<NotificationDataEntity> {
  final INotificationRepository _repository;

  GetNotificationsUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, NotificationDataEntity>> call() {
    return _repository.getNotifications();
  }
}
