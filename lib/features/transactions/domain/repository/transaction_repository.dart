import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_entity.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_enums.dart';

abstract interface class ITransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> getTransactions({
    required String shopId,
    int? page,
    int? limit,
    String? search,
    TransactionType? type,
    TransactionCategory? category,
    DateTime? startDate,
    DateTime? endDate,
    String? customerId,
    String? supplierId,
  });
}
