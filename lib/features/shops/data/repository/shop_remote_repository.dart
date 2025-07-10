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
  Future<Either<Failure, void>> createShop(
    String name,
    String? address,
    String? contactNumber,
  ) async {
    try {
      await _shopRemoteDataSource.createShop(name, address, contactNumber);
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
  Future<Either<Failure, List<ShopEntity>>> getShops() async {
    try {
      final shops = await _shopRemoteDataSource.getShops();
      final shopEntities = shops.map((model) => model.toEntity()).toList();
      return Right(shopEntities);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateShop(String id) {
    // TODO: implement updateShop
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> switchShop(String id) async {
    try {
      final success = await _shopRemoteDataSource.switchShop(id);
      return Right(success);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
