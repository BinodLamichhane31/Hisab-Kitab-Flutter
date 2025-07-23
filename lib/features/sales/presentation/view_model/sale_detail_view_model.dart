import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/cancel_sale_usecase.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/get_sale_by_id_usecase.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/record_payment_usecase.dart';
import 'package:hisab_kitab/features/sales/presentation/view_model/sale_detail_event.dart';
import 'package:hisab_kitab/features/sales/presentation/view_model/sale_detail_state.dart';

class SaleDetailViewModel extends Bloc<SaleDetailEvent, SaleDetailState> {
  final GetSaleByIdUsecase getSaleByIdUsecase;
  final CancelSaleUsecase cancelSaleUsecase;
  final RecordPaymentUsecase recordPaymentUsecase;
  final String saleId;

  SaleDetailViewModel({
    required this.getSaleByIdUsecase,
    required this.cancelSaleUsecase,
    required this.recordPaymentUsecase,
    required this.saleId,
  }) : super(const SaleDetailState.initial()) {
    on<LoadSaleDetailEvent>(_onLoadSaleDetail);
    on<CancelSaleEvent>(_onCancelSale);
    on<RecordPaymentEvent>(_onRecordPayment);

    add(LoadSaleDetailEvent(saleId: saleId));
  }

  Future<void> _onLoadSaleDetail(
    LoadSaleDetailEvent event,
    Emitter<SaleDetailState> emit,
  ) async {
    if (state.status == SaleDetailStatus.initial) {
      emit(state.copyWith(status: SaleDetailStatus.loading));
    }

    final result = await getSaleByIdUsecase(
      GetSaleByIdParams(saleId: event.saleId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SaleDetailStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (sale) => emit(
        state.copyWith(
          status: SaleDetailStatus.success,
          sale: sale,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  Future<void> _onCancelSale(
    CancelSaleEvent event,
    Emitter<SaleDetailState> emit,
  ) async {
    emit(state.copyWith(status: SaleDetailStatus.loading));

    final result = await cancelSaleUsecase(
      CancelSaleParams(saleId: event.saleId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SaleDetailStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (updatedSale) => emit(
        state.copyWith(
          status: SaleDetailStatus.cancelled,
          sale: updatedSale,
          successMessage: 'Sale has been successfully cancelled.',
        ),
      ),
    );
  }

  Future<void> _onRecordPayment(
    RecordPaymentEvent event,
    Emitter<SaleDetailState> emit,
  ) async {
    emit(state.copyWith(status: SaleDetailStatus.loading));

    final result = await recordPaymentUsecase(
      RecordPaymentParams(
        saleId: event.saleId,
        amountPaid: event.amountPaid,
        paymentMethod: event.paymentMethod,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SaleDetailStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (updatedSale) => emit(
        state.copyWith(
          status: SaleDetailStatus.paymentRecorded,
          sale: updatedSale,
          successMessage: 'Payment recorded successfully.',
        ),
      ),
    );
  }
}
