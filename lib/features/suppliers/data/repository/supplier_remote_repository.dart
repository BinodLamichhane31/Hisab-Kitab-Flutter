import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/suppliers/data/data_source/remote_data_source/supplier_remote_data_source.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';
import 'package:hisab_kitab/features/suppliers/domain/repository/supplier_repository.dart';

class SupplierRemoteRepository implements ISupplierRepository {
  final SupplierRemoteDataSource _supplierRemoteDataSource;

  SupplierRemoteRepository({
    required SupplierRemoteDataSource supplierRemoteDataSource,
  }) : _supplierRemoteDataSource = supplierRemoteDataSource;

  @override
  Future<Either<Failure, void>> addSupplier(SupplierEntity supplier) async {
    try {
      await _supplierRemoteDataSource.addSupplier(supplier);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> getSupplierById(
    String supplierId,
  ) async {
    try {
      final supplier = await _supplierRemoteDataSource.getSupplierById(
        supplierId,
      );
      return Right(supplier);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SupplierEntity>>> getSupplierByShop(
    String shopId, {
    String? search,
  }) async {
    try {
      final suppliers = await _supplierRemoteDataSource.getSupplierByShop(
        shopId,
        search: search,
      );
      return Right(suppliers);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> updateSupplier(
    SupplierEntity supplier,
  ) async {
    try {
      final updatedSupplier = await _supplierRemoteDataSource.updateSupplier(
        supplier,
      );
      return Right(updatedSupplier);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSupplier(String supplierId) async {
    try {
      final deleted = await _supplierRemoteDataSource.deleteSupplier(
        supplierId,
      );
      return Right(deleted);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
