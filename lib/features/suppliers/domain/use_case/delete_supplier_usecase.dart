import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/suppliers/domain/repository/supplier_repository.dart';

class DeleteSupplierParams extends Equatable {
  final String supplierId;

  const DeleteSupplierParams({required this.supplierId});

  @override
  List<Object?> get props => [supplierId];
}

class DeleteSupplierUsecase
    implements UseCaseWithParams<void, DeleteSupplierParams> {
  final ISupplierRepository supplierRepository;

  DeleteSupplierUsecase({required this.supplierRepository});

  @override
  Future<Either<Failure, void>> call(DeleteSupplierParams params) {
    return supplierRepository.deleteSupplier(params.supplierId);
  }
}
