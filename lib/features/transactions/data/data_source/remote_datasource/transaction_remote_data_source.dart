import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/features/transactions/data/data_source/transaction_data_source.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_enums.dart';

class TransactionRemoteDataSource implements ITransactionDataSource {
  final ApiService _apiService;

  TransactionRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  Map<String, dynamic> _decodeResponseData(Response response) {
    if (response.data is String && (response.data as String).isNotEmpty) {
      return json.decode(response.data) as Map<String, dynamic>;
    } else if (response.data is Map<String, dynamic>) {
      return response.data;
    }
    throw Exception(
      'Invalid response format: Expected a JSON object but got ${response.data.runtimeType}',
    );
  }

  @override
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
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'shopId': shopId};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (type != null) queryParams['type'] = type.name;
      if (category != null) queryParams['category'] = category.name;
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      if (customerId != null) queryParams['customerId'] = customerId;
      if (supplierId != null) queryParams['supplierId'] = supplierId;

      final response = await _apiService.dio.get(
        ApiEndpoints.transactions, // You need to add this endpoint
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final decodedData = _decodeResponseData(response);
        return PaginatedTransactionsResponse.fromJson(decodedData);
      } else {
        throw Exception(
          'Failed to fetch transactions. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message']?.toString() ?? e.message;
      throw Exception('API Error: $message');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
