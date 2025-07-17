import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';
import 'package:hisab_kitab/features/suppliers/domain/repository/supplier_repository.dart';

class GetSuppliersByShopParams extends Equatable {
  final String shopId;
  final String? search;

  const GetSuppliersByShopParams({required this.shopId, this.search});

  @override
  List<Object?> get props => [shopId, search];
}

class GetSuppliersByShopUsecase
    implements
        UseCaseWithParams<List<SupplierEntity>, GetSuppliersByShopParams> {
  final ISupplierRepository supplierRepository;

  GetSuppliersByShopUsecase({required this.supplierRepository});

  @override
  Future<Either<Failure, List<SupplierEntity>>> call(
    GetSuppliersByShopParams params,
  ) {
    final suppliers = supplierRepository.getSupplierByShop(params.shopId);
    return suppliers;
  }
}
