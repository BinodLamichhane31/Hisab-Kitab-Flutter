import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/get_sales_usecase.dart';
import 'package:hisab_kitab/features/sales/presentation/view_model/sale_event.dart';
import 'package:hisab_kitab/features/sales/presentation/view_model/sale_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

class SaleViewModel extends Bloc<SaleEvent, SaleState> {
  final GetSalesUsecase getSalesUsecase;
  final String shopId;

  static const int _salesLimit = 10;

  SaleViewModel({required this.getSalesUsecase, required this.shopId})
    : super(const SaleState.initial()) {
    on<LoadSalesEvent>(_onLoadSales, transformer: droppable());
    on<RefreshSalesEvent>(_onRefreshSales);

    add(LoadSalesEvent(shopId: shopId));
  }

  Future<void> _onLoadSales(
    LoadSalesEvent event,
    Emitter<SaleState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoading) return;

    emit(state.copyWith(isLoading: true));
    final nextPage = state.currentPage + 1;

    final result = await getSalesUsecase(
      GetSalesParams(
        shopId: event.shopId,
        page: nextPage,
        limit: _salesLimit,
        search: event.search,
        customerId: event.customerId,
        saleType: event.saleType,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (newSales) {
        emit(
          state.copyWith(
            sales: List.of(state.sales)..addAll(newSales),
            isLoading: false,
            currentPage: nextPage,
            hasReachedMax: newSales.length < _salesLimit,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshSales(
    RefreshSalesEvent event,
    Emitter<SaleState> emit,
  ) async {
    emit(const SaleState.initial());
    add(
      LoadSalesEvent(
        shopId: event.shopId,
        search: event.search,
        customerId: event.customerId,
        saleType: event.saleType,
      ),
    );
  }
}
