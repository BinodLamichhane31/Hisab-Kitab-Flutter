import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_entity.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_enums.dart';

class TransactionState extends Equatable {
  final List<TransactionEntity> transactions;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  final String? search;
  final TransactionType? type;
  final TransactionCategory? category;
  final DateTime? startDate;
  final DateTime? endDate;

  const TransactionState({
    required this.transactions,
    required this.isLoading,
    this.errorMessage,
    required this.currentPage,
    required this.hasReachedMax,
    this.search,
    this.type,
    this.category,
    this.startDate,
    this.endDate,
  });

  const TransactionState.initial()
    : transactions = const [],
      isLoading = false,
      errorMessage = null,
      currentPage = 0,
      hasReachedMax = false,
      search = null,
      type = null,
      category = null,
      startDate = null,
      endDate = null;

  TransactionState copyWith({
    List<TransactionEntity>? transactions,
    bool? isLoading,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
    String? search,
    TransactionType? type,
    TransactionCategory? category,
    DateTime? startDate,
    DateTime? endDate,
    bool clearError = false,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      search: search ?? this.search,
      type: type ?? this.type,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [
    transactions,
    isLoading,
    errorMessage,
    currentPage,
    hasReachedMax,
    search,
    type,
    category,
    startDate,
    endDate,
  ];
}
