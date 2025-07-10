import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

abstract interface class IShopRepository {
  Future<Either<Failure, List<ShopEntity>>> getShops();
  Future<Either<Failure, void>> createShop(
    String name,
    String? address,
    String? contactNumber,
  );
  Future<Either<Failure, void>> updateShop(String id);
  Future<Either<Failure, void>> deleteShop(String id);
}
