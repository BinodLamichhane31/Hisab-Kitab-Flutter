// lib/features/products/domain/repository/iproduct_repository.dart

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';

abstract interface class IProductRepository {
  Future<Either<Failure, ProductEntity>> addProduct(
    ProductEntity product, {
    File? imageFile,
  });

  Future<Either<Failure, List<ProductEntity>>> getProductsByShop(
    String shopId, {
    String? search,
  });

  Future<Either<Failure, ProductEntity>> getProductById(String productId);

  Future<Either<Failure, ProductEntity>> updateProduct(
    ProductEntity product, {
    File? imageFile,
  });

  Future<Either<Failure, bool>> deleteProduct(String productId);
}
