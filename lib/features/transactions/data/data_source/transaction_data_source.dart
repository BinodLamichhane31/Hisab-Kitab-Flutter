import 'package:hisab_kitab/features/transactions/data/model/transaction_api_model.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_enums.dart';

// A response model for paginated data from the API
class PaginatedTransactionsResponse {
  final List<TransactionApiModel> data;
  final Map<String, dynamic> pagination;

  PaginatedTransactionsResponse({required this.data, required this.pagination});

  factory PaginatedTransactionsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedTransactionsResponse(
      data:
          (json['data'] as List)
              .map((item) => TransactionApiModel.fromJson(item))
              .toList(),
      pagination: json['pagination'] as Map<String, dynamic>,
    );
  }
}

abstract interface class ITransactionDataSource {
  Future<PaginatedTransactionsResponse> getTransactions({
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
