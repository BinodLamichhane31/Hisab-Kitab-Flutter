import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/shops/domain/repository/shop_repository.dart';

class SwitchShopParams extends Equatable {
  final String shopId;

  const SwitchShopParams({required this.shopId});

  const SwitchShopParams.initial() : shopId = '_empty.string';

  @override
  List<Object?> get props => [shopId];
}

class SwitchShopUsecase implements UseCaseWithParams<bool, SwitchShopParams> {
  final IShopRepository shopRepository;

  SwitchShopUsecase({required this.shopRepository});

  @override
  Future<Either<Failure, bool>> call(SwitchShopParams params) async {
    return await shopRepository.switchShop(params.shopId);
  }
}
