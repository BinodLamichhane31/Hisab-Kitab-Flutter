import 'package:hisab_kitab/features/dashboard/domain/entity/chart_data_point_entity.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/dashboard_stats_entity.dart';

abstract class IDashboardDataSource {
  Future<DashboardStatsEntity> getDashboardStats(String shopId);
  Future<List<ChartDataPointEntity>> getChartData(String shopId);
}
