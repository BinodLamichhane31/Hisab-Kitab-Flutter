import 'package:hisab_kitab/features/shops/data/model/shop_api_model.dart';

abstract interface class IShopDataSource {
  Future<List<ShopApiModel>> getShops();
  Future<void> createShop(String name, String? address, String? contactNumber);
  Future<void> updateShop(String id);
  Future<void> deleteShop(String id);
  Future<bool> switchShop(String id);
}
