import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/dashboard/data/data_source/dashboard_data_source.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/dashboard_data_entity.dart';
import 'package:hisab_kitab/features/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRemoteRepository implements IDashboardRepository {
  final IDashboardDataSource _dashboardDataSource;

  DashboardRemoteRepository({required IDashboardDataSource dashboardDataSource})
    : _dashboardDataSource = dashboardDataSource;

  @override
  Future<Either<Failure, DashboardDataEntity>> getDashboardData({
    required String shopId,
  }) async {
    try {
      final (statsEntity, chartDataEntities) =
          await (
            _dashboardDataSource.getDashboardStats(shopId),
            _dashboardDataSource.getChartData(shopId),
          ).wait;

      return Right(
        DashboardDataEntity(stats: statsEntity, chartData: chartDataEntities),
      );
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
