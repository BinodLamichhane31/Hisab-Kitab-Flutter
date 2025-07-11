import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/shops/domain/repository/shop_repository.dart';

class CreateShopParams extends Equatable {
  final String shopName;
  final String? address;
  final String? contactNumber;

  const CreateShopParams({
    required this.shopName,
    this.address,
    this.contactNumber,
  });

  const CreateShopParams.initial()
    : shopName = '_empty.string',
      address = null,
      contactNumber = null;

  @override
  List<Object?> get props => [shopName, address, contactNumber];
}

class CreateShopUsecase implements UseCaseWithParams<void, CreateShopParams> {
  final IShopRepository shopRepository;

  CreateShopUsecase({required this.shopRepository});
  @override
  Future<Either<Failure, void>> call(CreateShopParams params) async {
    return await shopRepository.createShop(
      params.shopName,
      params.address,
      params.contactNumber,
    );
  }
}
