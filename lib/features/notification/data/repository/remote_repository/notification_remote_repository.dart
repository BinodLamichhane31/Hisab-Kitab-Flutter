import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/notification/data/data_source/remote_datasource/notification_remote_data_source.dart';
import 'package:hisab_kitab/features/notification/data/model/notification_api_model.dart';
import 'package:hisab_kitab/features/notification/domain/entity/notification_entity.dart';
import 'package:hisab_kitab/features/notification/domain/repository/notification_repository.dart';

class NotificationRemoteRepository implements INotificationRepository {
  final NotificationRemoteDataSource _dataSource;
  NotificationRemoteRepository({
    required NotificationRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Either<Failure, NotificationDataEntity>> getNotifications() async {
    try {
      final result = await _dataSource.getNotifications();
      final List<dynamic> jsonList = result['data'];
      final apiModels =
          jsonList.map((json) => NotificationApiModel.fromJson(json)).toList();

      return Right(
        NotificationDataEntity(
          notifications: NotificationApiModel.toEntityList(apiModels),
          unreadCount: result['count'] as int,
        ),
      );
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markAsRead(String notificationId) async {
    try {
      final success = await _dataSource.markAsRead(notificationId);
      return Right(success);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markAllAsRead() async {
    try {
      final success = await _dataSource.markAllAsRead();
      return Right(success);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, NotificationEntity>> listenForNotifications() {
    try {
      return _dataSource.listenForNotifications().map((apiModel) {
        return Right<Failure, NotificationEntity>(apiModel.toEntity());
      });
    } catch (e) {
      return Stream.value(
        Left(ApiFailure(message: 'Failed to listen to socket: $e')),
      );
    }
  }

  @override
  void disconnectListener() {
    _dataSource.disconnectListener();
  }
}
