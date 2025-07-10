import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/features/shops/data/data_source/shop_data_source.dart';
import 'package:hisab_kitab/features/shops/data/model/shop_api_model.dart';

class ShopRemoteDataSource implements IShopDataSource {
  final ApiService _apiService;

  ShopRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> createShop(
    String name,
    String? address,
    String? contactNumber,
  ) async {
    try {
      final Map<String, dynamic> requestBody = {
        'name': name,
        if (address != null && address.isNotEmpty) 'address': address,
        if (contactNumber != null && contactNumber.isNotEmpty)
          'contactNumber': contactNumber,
      };

      final response = await _apiService.dio.post(
        ApiEndpoints.shops,
        data: requestBody,
      );

      if (response.statusCode != 201) {
        throw Exception(
          'Failed to create shop: ${response.data['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ShopApiModel>> getShops() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.shops);
      if (response.statusCode == 200) {
        final List<dynamic> shopList = response.data['data'];
        return shopList.map((json) => ShopApiModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to get shops: ${response.data['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteShop(String id) {
    // TODO: implement deleteShop
    throw UnimplementedError();
  }

  @override
  Future<void> updateShop(String id) {
    // TODO: implement updateShop
    throw UnimplementedError();
  }
}
