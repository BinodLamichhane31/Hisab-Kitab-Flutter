import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/notification/domain/entity/notification_entity.dart';
import 'package:hisab_kitab/features/notification/domain/repository/notification_repository.dart';

class ListenForNotificationsUsecase
    implements
        UseCaseWithoutParams<Stream<Either<Failure, NotificationEntity>>> {
  final INotificationRepository _repository;
  ListenForNotificationsUsecase(this._repository);

  @override
  Stream<Either<Failure, NotificationEntity>> call() {
    return _repository.listenForNotifications();
  }
}
