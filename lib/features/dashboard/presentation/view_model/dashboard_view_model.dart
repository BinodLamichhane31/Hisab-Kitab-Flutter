import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/get_dashboard_data_usecase.dart';
import 'package:hisab_kitab/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:hisab_kitab/features/dashboard/presentation/view_model/dashboard_state.dart';

class DashboardViewModel extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardDataUsecase getDashboardDataUsecase;
  final String shopId;

  DashboardViewModel({
    required this.getDashboardDataUsecase,
    required this.shopId,
  }) : super(const DashboardState.initial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    final result = await getDashboardDataUsecase(shopId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DashboardStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(status: DashboardStatus.success, dashboardData: data),
      ),
    );
  }
}
