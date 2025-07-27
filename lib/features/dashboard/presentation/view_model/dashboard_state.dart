import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/dashboard_data_entity.dart';

enum DashboardStatus { initial, loading, success, error }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardDataEntity? dashboardData;
  final String? errorMessage;

  const DashboardState({
    required this.status,
    this.dashboardData,
    this.errorMessage,
  });

  const DashboardState.initial()
    : status = DashboardStatus.initial,
      dashboardData = null,
      errorMessage = null;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardDataEntity? dashboardData,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      dashboardData: dashboardData ?? this.dashboardData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, dashboardData, errorMessage];
}
