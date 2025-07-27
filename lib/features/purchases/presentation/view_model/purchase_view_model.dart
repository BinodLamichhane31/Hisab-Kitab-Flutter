import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/get_purchase_usecase.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/purchase_event.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/purchase_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

class PurchaseViewModel extends Bloc<PurchaseEvent, PurchaseState> {
  final GetPurchasesUsecase getPurchasesUsecase;
  final String shopId;

  static const int _purchasesLimit = 15;

  PurchaseViewModel({required this.getPurchasesUsecase, required this.shopId})
    : super(const PurchaseState.initial()) {
    on<LoadPurchasesEvent>(_onLoadPurchases, transformer: droppable());
    on<RefreshPurchasesEvent>(_onRefreshPurchases);

    add(LoadPurchasesEvent(shopId: shopId));
  }

  Future<void> _onLoadPurchases(
    LoadPurchasesEvent event,
    Emitter<PurchaseState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoading) return;

    emit(state.copyWith(isLoading: true));
    final nextPage = state.currentPage + 1;

    final result = await getPurchasesUsecase(
      GetPurchasesParams(
        shopId: event.shopId,
        page: nextPage,
        limit: _purchasesLimit,
        search: event.search,
        supplierId: event.supplierId,
        purchaseType: event.purchaseType,
      ),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (newPurchases) {
        emit(
          state.copyWith(
            purchases: List.of(state.purchases)..addAll(newPurchases),
            isLoading: false,
            currentPage: nextPage,
            hasReachedMax: newPurchases.length < _purchasesLimit,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshPurchases(
    RefreshPurchasesEvent event,
    Emitter<PurchaseState> emit,
  ) async {
    emit(const PurchaseState.initial());
    add(
      LoadPurchasesEvent(
        shopId: event.shopId,
        search: event.search,
        supplierId: event.supplierId,
        purchaseType: event.purchaseType,
      ),
    );
  }
}
