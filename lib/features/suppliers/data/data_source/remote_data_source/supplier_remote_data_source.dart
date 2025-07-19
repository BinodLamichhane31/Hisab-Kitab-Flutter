import 'package:dio/dio.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/features/suppliers/data/data_source/supplier_data_source.dart';
import 'package:hisab_kitab/features/suppliers/data/model/supplier_api_model.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';

class SupplierRemoteDataSource implements ISupplierDataSource {
  final ApiService _apiService;

  SupplierRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> addSupplier(SupplierEntity supplier) async {
    try {
      final supplierApiModel = SupplierApiModel.fromEntity(supplier);
      final response = await _apiService.dio.post(
        ApiEndpoints.suppliers,
        data: supplierApiModel.toJson(),
      );
      if (response.statusCode == 201) {
        return;
      }
    } on DioException catch (e) {
      throw Exception("Failed to add supplier: $e");
    } catch (e) {
      throw Exception("Unexpected error occured: $e");
    }
  }

  @override
  Future<bool> deleteSupplier(String supplierId) async {
    try {
      final response = await _apiService.dio.delete(
        ApiEndpoints.supplierById(supplierId),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(
        'Failed to delete supplier: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<SupplierEntity> getSupplierById(String supplierId) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.supplierById(supplierId),
      );

      if (response.statusCode == 200) {
        final customerJson = response.data['data'];
        final apiModel = SupplierApiModel.fromJson(customerJson);
        return apiModel.toEntity();
      } else {
        throw Exception('Server returned status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to get supplier: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<SupplierEntity>> getSupplierByShop(
    String shopId, {
    String? search,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'shopId': shopId};

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiService.dio.get(
        ApiEndpoints.suppliers,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> customerListJson = response.data['data'];
        final List<SupplierApiModel> apiModels =
            customerListJson
                .map((json) => SupplierApiModel.fromJson(json))
                .toList();
        return SupplierApiModel.toEntityList(apiModels);
      } else {
        throw Exception('Server returned status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to get customers: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<SupplierEntity> updateSupplier(SupplierEntity supplier) async {
    if (supplier.supplierId == null) {
      throw ArgumentError(
        "Customer ID cannot be null for an update operation.",
      );
    }

    try {
      final customerApiModel = SupplierApiModel.fromEntity(supplier);
      final response = await _apiService.dio.put(
        ApiEndpoints.supplierById(supplier.supplierId!),
        data: customerApiModel.toJson(),
      );
      if (response.statusCode == 200) {
        final updatedSupplierJson = response.data['data'];
        final updatedApiModel = SupplierApiModel.fromJson(updatedSupplierJson);
        return updatedApiModel.toEntity();
      } else {
        throw Exception(
          'Failed to update supplier. Server returned status code ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to update customer: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
