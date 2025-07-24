import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/cancel_purchase_usecase.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/get_purchase_by_id_usecase.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/record_payment_for_purchase_usecase.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/purchase_detail_event.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/purchase_detail_state.dart';

class PurchaseDetailViewModel
    extends Bloc<PurchaseDetailEvent, PurchaseDetailState> {
  final GetPurchaseByIdUsecase getPurchaseByIdUsecase;
  final CancelPurchaseUsecase cancelPurchaseUsecase;
  final RecordPaymentForPurchaseUsecase recordPaymentUsecase;
  final String purchaseId;

  PurchaseDetailViewModel({
    required this.getPurchaseByIdUsecase,
    required this.cancelPurchaseUsecase,
    required this.recordPaymentUsecase,
    required this.purchaseId,
  }) : super(const PurchaseDetailState.initial()) {
    on<LoadPurchaseDetailEvent>(_onLoadPurchaseDetail);
    on<CancelPurchaseEvent>(_onCancelPurchase);
    on<RecordPaymentEvent>(_onRecordPayment);

    add(LoadPurchaseDetailEvent(purchaseId: purchaseId));
  }

  Future<void> _onLoadPurchaseDetail(
    LoadPurchaseDetailEvent event,
    Emitter<PurchaseDetailState> emit,
  ) async {
    emit(
      state.copyWith(status: PurchaseDetailStatus.loading, clearMessages: true),
    );
    final result = await getPurchaseByIdUsecase(
      GetPurchaseByIdParams(purchaseId: event.purchaseId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PurchaseDetailStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (purchase) => emit(
        state.copyWith(
          status: PurchaseDetailStatus.success,
          purchase: purchase,
        ),
      ),
    );
  }

  Future<void> _onCancelPurchase(
    CancelPurchaseEvent event,
    Emitter<PurchaseDetailState> emit,
  ) async {
    emit(
      state.copyWith(status: PurchaseDetailStatus.loading, clearMessages: true),
    );
    final result = await cancelPurchaseUsecase(
      CancelPurchaseParams(purchaseId: event.purchaseId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PurchaseDetailStatus.error,
          errorMessage: failure.message,
          purchase: state.purchase,
        ),
      ),
      (updatedPurchase) => emit(
        state.copyWith(
          status: PurchaseDetailStatus.cancelled,
          purchase: updatedPurchase,
          successMessage: 'Purchase has been successfully cancelled.',
        ),
      ),
    );
  }

  Future<void> _onRecordPayment(
    RecordPaymentEvent event,
    Emitter<PurchaseDetailState> emit,
  ) async {
    emit(
      state.copyWith(status: PurchaseDetailStatus.loading, clearMessages: true),
    );
    final result = await recordPaymentUsecase(
      RecordPaymentForPurchaseParams(
        purchaseId: event.purchaseId,
        amountPaid: event.amountPaid,
        paymentMethod: event.paymentMethod,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PurchaseDetailStatus.error,
          errorMessage: failure.message,
          purchase: state.purchase,
        ),
      ),
      (updatedPurchase) => emit(
        state.copyWith(
          status: PurchaseDetailStatus.paymentRecorded,
          purchase: updatedPurchase,
          successMessage: 'Payment recorded successfully.',
        ),
      ),
    );
  }
}
