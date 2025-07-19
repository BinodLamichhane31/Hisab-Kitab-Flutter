import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';
import 'package:hisab_kitab/features/suppliers/domain/repository/supplier_repository.dart';

class GetSupplierParams extends Equatable {
  final String supplierId;

  const GetSupplierParams({required this.supplierId});

  @override
  List<Object?> get props => [supplierId];
}

class GetSupplierUsecase
    implements UseCaseWithParams<SupplierEntity, GetSupplierParams> {
  final ISupplierRepository supplierRepository;

  GetSupplierUsecase({required this.supplierRepository});

  @override
  Future<Either<Failure, SupplierEntity>> call(GetSupplierParams params) {
    return supplierRepository.getSupplierById(params.supplierId);
  }
}
