import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/shops/data/data_source/remote_data_source/shop_remote_data_source.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';
import 'package:hisab_kitab/features/shops/domain/repository/shop_repository.dart';

class ShopRemoteRepository implements IShopRepository {
  final ShopRemoteDataSource _shopRemoteDataSource;

  ShopRemoteRepository({required ShopRemoteDataSource shopRemoteDataSource})
    : _shopRemoteDataSource = shopRemoteDataSource;
  @override
  Future<Either<Failure, void>> createShop(ShopEntity shop) async {
    try {
      await _shopRemoteDataSource.createShop(shop);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteShop(String id) {
    // TODO: implement deleteShop
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ShopEntity>>> getShops() {
    // TODO: implement getShops
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateShop(String id) {
    // TODO: implement updateShop
    throw UnimplementedError();
  }
}
