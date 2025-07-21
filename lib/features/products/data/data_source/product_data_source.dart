import 'dart:io';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';

abstract interface class IProductDataSource {
  Future<ProductEntity> addProduct(ProductEntity product, {File? imageFile});

  Future<List<ProductEntity>> getProductsByShop(
    String shopId, {
    int? page,
    int? limit,
    String? search,
  });

  Future<ProductEntity> getProductById(String productId);

  Future<ProductEntity> updateProduct(ProductEntity product, {File? imageFile});

  Future<bool> deleteProduct(String productId);
}
