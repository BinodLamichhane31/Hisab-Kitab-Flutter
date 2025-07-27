import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/dashboard_data_entity.dart';

abstract class IDashboardRepository {
  Future<Either<Failure, DashboardDataEntity>> getDashboardData({
    required String shopId,
  });
}
