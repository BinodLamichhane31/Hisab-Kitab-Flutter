import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

abstract interface class IShopDataSource {
  Future<List<ShopEntity>> getShops();
  Future<void> createShop(ShopEntity shop);
  Future<void> updateShop(String id);
  Future<void> deleteShop(String id);
}
