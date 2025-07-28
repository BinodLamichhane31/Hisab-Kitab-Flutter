import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/notification/domain/repository/notification_repository.dart';

class MarkAsReadUsecase implements UseCaseWithParams<bool, String> {
  final INotificationRepository _repository;

  MarkAsReadUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(String notificationId) {
    return _repository.markAsRead(notificationId);
  }
}
