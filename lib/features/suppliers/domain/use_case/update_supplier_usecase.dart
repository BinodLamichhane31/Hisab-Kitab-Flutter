import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';
import 'package:hisab_kitab/features/suppliers/domain/repository/supplier_repository.dart';

class UpdateSupplierParams extends Equatable {
  final SupplierEntity supplier;

  const UpdateSupplierParams({required this.supplier});

  @override
  List<Object?> get props => [supplier];
}

class UpdateSupplierUsecase
    implements UseCaseWithParams<SupplierEntity, UpdateSupplierParams> {
  final ISupplierRepository supplierRepository;

  UpdateSupplierUsecase({required this.supplierRepository});

  @override
  Future<Either<Failure, SupplierEntity>> call(UpdateSupplierParams params) {
    return supplierRepository.updateSupplier(params.supplier);
  }
}
