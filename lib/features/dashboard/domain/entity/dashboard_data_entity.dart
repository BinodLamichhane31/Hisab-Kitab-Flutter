import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/chart_data_point_entity.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/dashboard_stats_entity.dart';

class DashboardDataEntity extends Equatable {
  final DashboardStatsEntity stats;
  final List<ChartDataPointEntity> chartData;

  const DashboardDataEntity({required this.stats, required this.chartData});

  @override
  List<Object?> get props => [stats, chartData];
}
