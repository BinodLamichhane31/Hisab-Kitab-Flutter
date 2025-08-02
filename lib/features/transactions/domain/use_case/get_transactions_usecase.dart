import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_entity.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_enums.dart';
import 'package:hisab_kitab/features/transactions/domain/repository/transaction_repository.dart';

class GetTransactionsParams extends Equatable {
  final String shopId;
  final int? page;
  final int? limit;
  final String? search;
  final TransactionType? type;
  final TransactionCategory? category;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? customerId;
  final String? supplierId;

  const GetTransactionsParams({
    required this.shopId,
    this.page,
    this.limit,
    this.search,
    this.type,
    this.category,
    this.startDate,
    this.endDate,
    this.customerId,
    this.supplierId,
  });

  @override
  List<Object?> get props => [
    shopId,
    page,
    limit,
    search,
    type,
    category,
    startDate,
    endDate,
    customerId,
    supplierId,
  ];
}

class GetTransactionsUsecase
    implements
        UseCaseWithParams<List<TransactionEntity>, GetTransactionsParams> {
  final ITransactionRepository _repository;

  GetTransactionsUsecase({required ITransactionRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(
    GetTransactionsParams params,
  ) {
    return _repository.getTransactions(
      shopId: params.shopId,
      page: params.page,
      limit: params.limit,
      search: params.search,
      type: params.type,
      category: params.category,
      startDate: params.startDate,
      endDate: params.endDate,
      customerId: params.customerId,
      supplierId: params.supplierId,
    );
  }
}
