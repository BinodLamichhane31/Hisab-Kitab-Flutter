import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';
import 'package:hisab_kitab/features/shops/domain/repository/shop_repository.dart';

class GetAllShopsUsecase implements UseCaseWithoutParams<List<ShopEntity>> {
  final IShopRepository shopRepository;

  GetAllShopsUsecase({required this.shopRepository});

  @override
  Future<Either<Failure, List<ShopEntity>>> call() async {
    return await shopRepository.getShops();
  }
}
