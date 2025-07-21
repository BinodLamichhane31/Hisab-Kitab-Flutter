import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';

abstract interface class ISupplierRepository {
  Future<Either<Failure, void>> addSupplier(SupplierEntity supplier);
  Future<Either<Failure, List<SupplierEntity>>> getSupplierByShop(
    String shopId, {
    String? search,
  });
  Future<Either<Failure, SupplierEntity>> getSupplierById(String supplierId);
  Future<Either<Failure, SupplierEntity>> updateSupplier(
    SupplierEntity supplier,
  );
  Future<Either<Failure, bool>> deleteSupplier(String supplierId);
}
