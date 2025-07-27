import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/features/purchases/data/data_source/purchase_data_source.dart';
import 'package:hisab_kitab/features/purchases/data/model/purchase_api_model.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_enums.dart';

class PurchaseRemoteDataSource implements IPurchaseDataSource {
  final ApiService _apiService;

  PurchaseRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  /// Helper to decode response data safely
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
  Future<PaginatedPurchasesResponse> getPurchases({
    required String shopId,
    int? page,
    int? limit,
    String? search,
    String? supplierId,
    PurchaseType? purchaseType,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'shopId': shopId};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (supplierId != null) queryParams['supplierId'] = supplierId;
      if (purchaseType != null) {
        queryParams['purchaseType'] = purchaseType.name.toUpperCase();
      }

      final response = await _apiService.dio.get(
        ApiEndpoints.purchases,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final decodedData = _decodeResponseData(response);
        return PaginatedPurchasesResponse.fromJson(decodedData);
      } else {
        throw Exception(
          'Failed to get purchases. Server returned status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message']?.toString() ?? e.message;
      throw Exception('API Error: $message');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<PurchaseApiModel> getPurchaseById(String purchaseId) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.purchaseById(purchaseId),
      );
      if (response.statusCode == 200) {
        final decodedData = _decodeResponseData(response);
        // Assuming the single purchase is nested under a 'data' key
        if (decodedData['data'] is Map<String, dynamic>) {
          return PurchaseApiModel.fromJson(decodedData['data']);
        }
        throw Exception(
          "Could not find 'data' key in the response for getPurchaseById",
        );
      } else {
        throw Exception(
          'Failed to get purchase details. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message']?.toString() ?? e.message;
      throw Exception('API Error: $message');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<PurchaseApiModel> createPurchase(
    Map<String, dynamic> purchaseData,
  ) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.purchases,
        data: purchaseData,
      );
      if (response.statusCode == 201) {
        final decodedData = _decodeResponseData(response);
        if (decodedData['data'] is Map<String, dynamic>) {
          return PurchaseApiModel.fromJson(decodedData['data']);
        }
        throw Exception(
          "Could not find 'data' key in the response for createPurchase",
        );
      } else {
        throw Exception(
          'Failed to create purchase. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message']?.toString() ?? e.message;
      throw Exception('API Error: $message');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<PurchaseApiModel> cancelPurchase(String purchaseId) async {
    try {
      final response = await _apiService.dio.put(
        '${ApiEndpoints.purchaseById(purchaseId)}/cancel',
      );
      if (response.statusCode == 200) {
        final decodedData = _decodeResponseData(response);
        if (decodedData['data'] is Map<String, dynamic>) {
          return PurchaseApiModel.fromJson(decodedData['data']);
        }
        throw Exception(
          "Could not find 'data' key in the response for cancelPurchase",
        );
      } else {
        throw Exception(
          'Failed to cancel purchase. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message']?.toString() ?? e.message;
      throw Exception('API Error: $message');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<PurchaseApiModel> recordPaymentForPurchase({
    required String purchaseId,
    required double amountPaid,
    String? paymentMethod,
  }) async {
    try {
      final Map<String, dynamic> body = {'amountPaid': amountPaid};
      if (paymentMethod != null) {
        body['paymentMethod'] = paymentMethod;
      }
      final response = await _apiService.dio.put(
        '${ApiEndpoints.purchaseById(purchaseId)}/payment',
        data: body,
      );
      if (response.statusCode == 200) {
        final decodedData = _decodeResponseData(response);
        if (decodedData['data'] is Map<String, dynamic>) {
          return PurchaseApiModel.fromJson(decodedData['data']);
        }
        throw Exception(
          "Could not find 'data' key in the response for recordPayment",
        );
      } else {
        throw Exception(
          'Failed to record payment. Status: ${response.statusCode}',
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
