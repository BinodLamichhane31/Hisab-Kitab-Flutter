import 'package:dio/dio.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/features/sales/data/data_source/sale_data_source.dart';
import 'package:hisab_kitab/features/sales/data/model/sale_api_model.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_enums.dart';

class SaleRemoteDataSource implements ISaleDataSource {
  final ApiService _apiService;

  SaleRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<SaleApiModel> createSale(Map<String, dynamic> saleData) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.sales,
        data: saleData,
      );

      if (response.statusCode == 201) {
        return SaleApiModel.fromJson(response.data['data']);
      } else {
        throw Exception(
          'Failed to create sale. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to create sale: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<PaginatedSalesResponse> getSales({
    required String shopId,
    int? page,
    int? limit,
    String? search,
    String? customerId,
    SaleType? saleType,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'shopId': shopId};

      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (customerId != null) queryParams['customerId'] = customerId;
      if (saleType != null) {
        queryParams['saleType'] = saleType.name.toUpperCase();
      }

      final response = await _apiService.dio.get(
        ApiEndpoints.sales,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return PaginatedSalesResponse.fromJson(response.data);
      } else {
        throw Exception('Server returned status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to get sales: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<SaleApiModel> getSaleById(String saleId) async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.saleById(saleId));

      if (response.statusCode == 200) {
        return SaleApiModel.fromJson(response.data['data']);
      } else {
        throw Exception('Server returned status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to get sale details: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<SaleApiModel> cancelSale(String saleId) async {
    try {
      final response = await _apiService.dio.put(
        '${ApiEndpoints.saleById(saleId)}/cancel',
      );

      if (response.statusCode == 200) {
        return SaleApiModel.fromJson(response.data['data']);
      } else {
        throw Exception(
          'Failed to cancel sale. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to cancel sale: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<SaleApiModel> recordPayment({
    required String saleId,
    required double amountPaid,
    String? paymentMethod,
  }) async {
    try {
      final Map<String, dynamic> body = {'amountPaid': amountPaid};
      if (paymentMethod != null) {
        body['paymentMethod'] = paymentMethod;
      }

      final response = await _apiService.dio.post(
        '${ApiEndpoints.saleById(saleId)}/payment',
        data: body,
      );

      if (response.statusCode == 200) {
        return SaleApiModel.fromJson(response.data['data']);
      } else {
        throw Exception(
          'Failed to record payment. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to record payment: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
