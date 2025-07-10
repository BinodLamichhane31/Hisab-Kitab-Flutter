import 'package:dio/dio.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/features/shops/data/data_source/shop_data_source.dart';
import 'package:hisab_kitab/features/shops/data/model/shop_api_model.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

class ShopRemoteDataSource implements IShopDataSource {
  final ApiService _apiService;

  ShopRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;
  @override
  Future<void> createShop(ShopEntity shop) async {
    try {
      final shopApiModel = ShopApiModel.fromEntity(shop);
      var response = await _apiService.dio.post(
        ApiEndpoints.shop,
        data: shopApiModel.toJson(),
      );
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception('Failed to add shop: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to add shop: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected errror occured: $e}');
    }
  }

  @override
  Future<void> deleteShop(String id) {
    // TODO: implement deleteShop
    throw UnimplementedError();
  }

  @override
  Future<List<ShopEntity>> getShops() {
    // TODO: implement getShops
    throw UnimplementedError();
  }

  @override
  Future<void> updateShop(String id) {
    // TODO: implement updateShop
    throw UnimplementedError();
  }
}
