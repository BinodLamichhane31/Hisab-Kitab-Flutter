import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_enums.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends TransactionEvent {
  final String shopId;
  final String? search;
  final TransactionType? type;
  final TransactionCategory? category;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadTransactionsEvent({
    required this.shopId,
    this.search,
    this.type,
    this.category,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
    shopId,
    search,
    type,
    category,
    startDate,
    endDate,
  ];
}

class RefreshTransactionsEvent extends TransactionEvent {
  final String shopId;
  final String? search;
  final TransactionType? type;
  final TransactionCategory? category;
  final DateTime? startDate;
  final DateTime? endDate;

  const RefreshTransactionsEvent({
    required this.shopId,
    this.search,
    this.type,
    this.category,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
    shopId,
    search,
    type,
    category,
    startDate,
    endDate,
  ];
}
