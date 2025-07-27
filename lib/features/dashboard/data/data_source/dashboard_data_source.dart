import 'package:hisab_kitab/features/dashboard/domain/entity/chart_data_point_entity.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/dashboard_stats_entity.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_in_usecase.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_out_usecase.dart';

abstract class IDashboardDataSource {
  Future<DashboardStatsEntity> getDashboardStats(String shopId);
  Future<List<ChartDataPointEntity>> getChartData(String shopId);
  Future<String> recordCashIn(RecordCashInParams params);
  Future<String> recordCashOut(RecordCashOutParams params);
}
