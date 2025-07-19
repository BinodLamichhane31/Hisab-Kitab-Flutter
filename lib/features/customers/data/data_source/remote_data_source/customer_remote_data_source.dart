import 'package:dio/dio.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/features/customers/data/data_source/customer_data_source.dart';
import 'package:hisab_kitab/features/customers/data/model/customer_api_model.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';

class CustomerRemoteDataSource implements ICustomerDataSource {
  final ApiService _apiService;

  CustomerRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> addCustomer(CustomerEntity customer) async {
    try {
      final customerApiModel = CustomerApiModel.fromEntity(customer);
      final response = await _apiService.dio.post(
        ApiEndpoints.customers,
        data: customerApiModel.toJson(),
      );
      if (response.statusCode == 201) {
        return;
      }
    } on DioException catch (e) {
      throw Exception("Failed to add customer: $e");
    } catch (e) {
      throw Exception("Unexpected error occured: $e");
    }
  }

  @override
  Future<bool> deleteCustomer(String customerId) async {
    try {
      final response = await _apiService.dio.delete(
        ApiEndpoints.customerById(customerId),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(
        'Failed to delete customer: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<CustomerEntity> getCustomerById(String customerId) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.customerById(customerId),
      );

      if (response.statusCode == 200) {
        final customerJson = response.data['data'];
        final apiModel = CustomerApiModel.fromJson(customerJson);
        return apiModel.toEntity();
      } else {
        throw Exception('Server returned status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to get customer: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<CustomerEntity>> getCustomerByShop(
    String shopId, {
    String? search,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'shopId': shopId};

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiService.dio.get(
        ApiEndpoints.customers,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> customerListJson = response.data['data'];
        final List<CustomerApiModel> apiModels =
            customerListJson
                .map((json) => CustomerApiModel.fromJson(json))
                .toList();
        return CustomerApiModel.toEntityList(apiModels);
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
  @override
  @override
  Future<CustomerEntity> updateCustomer(CustomerEntity customer) async {
    if (customer.customerId == null) {
      throw ArgumentError(
        "Customer ID cannot be null for an update operation.",
      );
    }

    try {
      final customerApiModel = CustomerApiModel.fromEntity(customer);
      final response = await _apiService.dio.put(
        ApiEndpoints.customerById(customer.customerId!),
        data: customerApiModel.toJson(),
      );
      if (response.statusCode == 200) {
        final updatedCustomerJson = response.data['data'];
        final updatedApiModel = CustomerApiModel.fromJson(updatedCustomerJson);
        return updatedApiModel.toEntity();
      } else {
        throw Exception(
          'Failed to update customer. Server returned status code ${response.statusCode}',
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
