import 'package:hisab_kitab/features/shops/data/model/shop_api_model.dart';

List<ShopApiModel> shopsFromJson(dynamic json) {
  if (json is List) {
    return json
        .map((item) {
          if (item is Map<String, dynamic>) {
            return ShopApiModel.fromJson(item);
          }
          return null;
        })
        .whereType<ShopApiModel>() // Filters out any nulls from invalid items
        .toList();
  }
  return []; // Return an empty list if json is not a List
}

/// Helper function to safely parse the active shop from JSON.
/// It handles cases where the field might be a populated object (Map),
/// an unpopulated ID (String), or null.
ShopApiModel? activeShopFromJson(dynamic json) {
  if (json is Map<String, dynamic>) {
    return ShopApiModel.fromJson(json);
  }
  // If it's a String (ID) or null, we cannot create a full ShopApiModel,
  // so we return null.
  return null;
}

/// Helper function to convert a list of shops back to JSON.
List<Map<String, dynamic>> shopsToJson(List<ShopApiModel> shops) {
  return shops.map((shop) => shop.toJson()).toList();
}

/// Helper function to convert the active shop back to JSON.
Map<String, dynamic>? activeShopToJson(ShopApiModel? shop) {
  return shop?.toJson();
}
