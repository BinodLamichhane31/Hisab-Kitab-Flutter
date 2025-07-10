import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';
import 'package:hisab_kitab/features/shops/domain/repository/shop_repository.dart';

class CreateShopParams extends Equatable {
  final String shopName;
  final String? address;
  final String? contactNumber;
  final String ownerId;

  const CreateShopParams({
    required this.shopName,
    this.address,
    this.contactNumber,
    required this.ownerId,
  });

  const CreateShopParams.initial()
    : shopName = '_empty.string',
      address = null,
      contactNumber = null,
      ownerId = '_empty.string';

  @override
  List<Object?> get props => [shopName, address, contactNumber, ownerId];
}

class CreateShopUsecase implements UseCaseWithParams<void, CreateShopParams> {
  final IShopRepository shopRepository;

  CreateShopUsecase({required this.shopRepository});
  @override
  Future<Either<Failure, void>> call(CreateShopParams params) async {
    return await shopRepository.createShop(
      ShopEntity(
        shopName: params.shopName,
        address: params.address,
        contactNumber: params.contactNumber,
        ownerId: params.ownerId,
      ),
    );
  }
}
