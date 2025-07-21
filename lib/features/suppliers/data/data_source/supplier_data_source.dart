import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';

abstract interface class ISupplierDataSource {
  Future<void> addSupplier(SupplierEntity supplier);
  Future<List<SupplierEntity>> getSupplierByShop(
    String shopId, {
    String? search,
  });
  Future<SupplierEntity> getSupplierById(String supplierId);
  Future<SupplierEntity> updateSupplier(SupplierEntity supplier);
  Future<bool> deleteSupplier(String supplierId);
}
