import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/get_dashboard_data_usecase.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_in_usecase.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_out_usecase.dart';
import 'package:hisab_kitab/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:hisab_kitab/features/dashboard/presentation/view_model/dashboard_state.dart';

class DashboardViewModel extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardDataUsecase getDashboardDataUsecase;
  final RecordCashInUsecase recordCashInUsecase;
  final RecordCashOutUsecase recordCashOutUsecase;
  final String shopId;

  DashboardViewModel({
    required this.getDashboardDataUsecase,
    required this.recordCashInUsecase,
    required this.recordCashOutUsecase,
    required this.shopId,
  }) : super(const DashboardState.initial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RecordCashInSubmitted>(_onRecordCashIn);
    on<RecordCashOutSubmitted>(_onRecordCashOut);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      state.copyWith(
        status: DashboardStatus.loading,
        clearSuccessMessage: true,
        clearErrorMessage: true,
      ),
    );
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

  Future<void> _onRecordCashIn(
    RecordCashInSubmitted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      state.copyWith(
        status: DashboardStatus.submitting,
        clearSuccessMessage: true,
        clearErrorMessage: true,
      ),
    );
    final result = await recordCashInUsecase(event.params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DashboardStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (successMessage) => emit(
        state.copyWith(
          status: DashboardStatus.success,
          successMessage: successMessage,
        ),
      ),
    );
  }

  Future<void> _onRecordCashOut(
    RecordCashOutSubmitted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      state.copyWith(
        status: DashboardStatus.submitting,
        clearSuccessMessage: true,
        clearErrorMessage: true,
      ),
    );
    final result = await recordCashOutUsecase(event.params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DashboardStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (successMessage) => emit(
        state.copyWith(
          status: DashboardStatus.success,
          successMessage: successMessage,
        ),
      ),
    );
  }
}
