import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/transactions/data/data_source/transaction_data_source.dart';
import 'package:hisab_kitab/features/transactions/data/model/transaction_api_model.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_entity.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_enums.dart';
import 'package:hisab_kitab/features/transactions/domain/repository/transaction_repository.dart';

class TransactionRemoteRepository implements ITransactionRepository {
  final ITransactionDataSource _dataSource;

  TransactionRemoteRepository({required ITransactionDataSource dataSource})
    : _dataSource = dataSource;

  @override
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
  }) async {
    try {
      final response = await _dataSource.getTransactions(
        shopId: shopId,
        page: page,
        limit: limit,
        search: search,
        type: type,
        category: category,
        startDate: startDate,
        endDate: endDate,
        customerId: customerId,
        supplierId: supplierId,
      );
      return Right(TransactionApiModel.toEntityList(response.data));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
