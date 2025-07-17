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
  Future<bool> deleteSupplier(String supplierId) {
    // TODO: implement deleteCustomer
    throw UnimplementedError();
  }

  @override
  Future<SupplierEntity> getSupplierById(String supplierId) {
    // TODO: implement getSupplierById
    throw UnimplementedError();
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
  Future<SupplierEntity> updateSupplier(SupplierEntity supplier) {
    // TODO: implement updateCustomer
    throw UnimplementedError();
  }
}
