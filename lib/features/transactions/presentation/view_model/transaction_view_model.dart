import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/transactions/domain/use_case/get_transactions_usecase.dart';
import 'package:hisab_kitab/features/transactions/presentation/view_model/transaction_event.dart';
import 'package:hisab_kitab/features/transactions/presentation/view_model/transaction_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

class TransactionViewModel extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsUsecase getTransactionsUsecase;
  final String shopId;

  static const int _transactionsLimit = 20;

  TransactionViewModel({
    required this.getTransactionsUsecase,
    required this.shopId,
  }) : super(const TransactionState.initial()) {
    on<LoadTransactionsEvent>(_onLoadTransactions, transformer: droppable());
    on<RefreshTransactionsEvent>(
      _onRefreshTransactions,
      transformer: restartable(),
    );

    add(LoadTransactionsEvent(shopId: shopId));
  }

  Future<void> _onLoadTransactions(
    LoadTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoading) return;

    emit(state.copyWith(isLoading: true));
    final nextPage = state.currentPage + 1;

    final result = await getTransactionsUsecase(
      GetTransactionsParams(
        shopId: event.shopId,
        page: nextPage,
        limit: _transactionsLimit,
        search: event.search,
        type: event.type,
        category: event.category,
        startDate: event.startDate,
        endDate: event.endDate,
        customerId: event.customerId,
        supplierId: event.supplierId,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (newTransactions) {
        emit(
          state.copyWith(
            transactions: List.of(state.transactions)..addAll(newTransactions),
            isLoading: false,
            currentPage: nextPage,
            hasReachedMax: newTransactions.length < _transactionsLimit,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshTransactions(
    RefreshTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(
      TransactionState.initial().copyWith(
        search: event.search,
        type: event.type,
        category: event.category,
        startDate: event.startDate,
        endDate: event.endDate,
        customerId: event.customerId,
        supplierId: event.supplierId,
      ),
    );

    add(
      LoadTransactionsEvent(
        shopId: event.shopId,
        search: event.search,
        type: event.type,
        category: event.category,
        startDate: event.startDate,
        endDate: event.endDate,
        customerId: event.customerId,
        supplierId: event.supplierId,
      ),
    );
  }
}
