import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/features/products/data/data_source/product_data_source.dart';
import 'package:hisab_kitab/features/products/data/model/product_api_model.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';

class ProductRemoteDataSource implements IProductDataSource {
  final ApiService _apiService;

  ProductRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<ProductEntity> addProduct(
    ProductEntity product, {
    File? imageFile,
  }) async {
    try {
      final productMap = ProductApiModel.fromEntity(product).toJson();
      productMap.removeWhere((key, value) => value == null);
      final formData = FormData.fromMap(productMap);
      if (imageFile != null) {
        final fileName = imageFile.path.split('/').last;
        formData.files.add(
          MapEntry(
            'productImage',
            await MultipartFile.fromFile(
              imageFile.path,
              filename: fileName,
              contentType: DioMediaType.parse(_getContentType(fileName)),
            ),
          ),
        );
      }

      final response = await _apiService.dio.post(
        ApiEndpoints.products,
        data: formData,
      );

      if (response.statusCode == 201) {
        final newProductJson = response.data['data'];
        final apiModel = ProductApiModel.fromJson(newProductJson);
        return apiModel.toEntity();
      } else {
        throw Exception(
          'Failed to add product. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to add product: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<bool> deleteProduct(String productId) async {
    try {
      final response = await _apiService.dio.delete(
        ApiEndpoints.productById(productId),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(
        'Failed to delete product: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<ProductEntity> getProductById(String productId) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.productById(productId),
      );

      if (response.statusCode == 200) {
        final productJson = response.data['data'];
        final apiModel = ProductApiModel.fromJson(productJson);
        return apiModel.toEntity();
      } else {
        throw Exception('Server returned status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to get product: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByShop(
    String shopId, {
    int? page,
    int? limit,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'shopId': shopId};

      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await _apiService.dio.get(
        ApiEndpoints.products,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> productListJson = response.data['data'];
        final List<ProductApiModel> apiModels =
            productListJson
                .map((json) => ProductApiModel.fromJson(json))
                .toList();
        return ProductApiModel.toEntityList(apiModels);
      } else {
        throw Exception('Server returned status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to get products: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<ProductEntity> updateProduct(
    ProductEntity product, {
    File? imageFile,
  }) async {
    if (product.productId == null) {
      throw ArgumentError("Product ID cannot be null for an update operation.");
    }

    try {
      final productMap = ProductApiModel.fromEntity(product).toJson();
      productMap.removeWhere((key, value) => value == null);
      productMap.remove('_id');

      final formData = FormData.fromMap(productMap);

      if (imageFile != null) {
        final fileName = imageFile.path.split('/').last;
        formData.files.add(
          MapEntry(
            'productImage',
            await MultipartFile.fromFile(
              imageFile.path,
              filename: fileName,
              contentType: DioMediaType.parse(_getContentType(fileName)),
            ),
          ),
        );
      }
      final response = await _apiService.dio.put(
        ApiEndpoints.productById(product.productId!),
        data: formData,
      );

      if (response.statusCode == 200) {
        final updatedProductJson = response.data['data'];
        final updatedApiModel = ProductApiModel.fromJson(updatedProductJson);
        return updatedApiModel.toEntity();
      } else {
        throw Exception(
          'Failed to update product. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to update product: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  String _getContentType(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg'; // Default fallback
    }
  }
}
