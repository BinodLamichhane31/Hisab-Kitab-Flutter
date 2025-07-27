import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/dashboard_data_entity.dart';

enum DashboardStatus { initial, loading, success, error, submitting }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardDataEntity? dashboardData;
  final String? errorMessage;
  final String? successMessage;

  const DashboardState({
    required this.status,
    this.dashboardData,
    this.errorMessage,
    this.successMessage,
  });

  const DashboardState.initial()
    : status = DashboardStatus.initial,
      dashboardData = null,
      errorMessage = null,
      successMessage = null;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardDataEntity? dashboardData,
    String? errorMessage,
    String? successMessage,
    bool clearSuccessMessage = false,
    bool clearErrorMessage = false,
  }) {
    return DashboardState(
      status: status ?? this.status,
      dashboardData: dashboardData ?? this.dashboardData,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      successMessage:
          clearSuccessMessage ? null : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    dashboardData,
    errorMessage,
    successMessage,
  ];
}
