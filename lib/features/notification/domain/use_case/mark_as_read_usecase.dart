import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/notification/domain/repository/notification_repository.dart';

class MarkAllAsReadUsecase implements UseCaseWithoutParams<bool> {
  final INotificationRepository _repository;

  MarkAllAsReadUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call() {
    return _repository.markAllAsRead();
  }
}
