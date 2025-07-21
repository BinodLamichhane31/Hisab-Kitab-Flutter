import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/products/data/data_source/remote_data_source/product_remote_data_source.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';
import 'package:hisab_kitab/features/products/domain/repository/product_repository.dart';

class ProductRemoteRepository implements IProductRepository {
  final ProductRemoteDataSource _productRemoteDataSource;

  ProductRemoteRepository({
    required ProductRemoteDataSource productRemoteDataSource,
  }) : _productRemoteDataSource = productRemoteDataSource;

  @override
  Future<Either<Failure, ProductEntity>> addProduct(
    ProductEntity product, {
    File? imageFile,
  }) async {
    try {
      final newProduct = await _productRemoteDataSource.addProduct(
        product,
        imageFile: imageFile,
      );
      return Right(newProduct);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(String productId) async {
    try {
      final deleted = await _productRemoteDataSource.deleteProduct(productId);
      return Right(deleted);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(
    String productId,
  ) async {
    try {
      final product = await _productRemoteDataSource.getProductById(productId);
      return Right(product);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByShop(
    String shopId, {
    int? page,
    int? limit,
    String? search,
  }) async {
    try {
      final products = await _productRemoteDataSource.getProductsByShop(
        shopId,
        page: page,
        limit: limit,
        search: search,
      );
      return Right(products);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct(
    ProductEntity product, {
    File? imageFile,
  }) async {
    try {
      final updatedProduct = await _productRemoteDataSource.updateProduct(
        product,
        imageFile: imageFile,
      );
      return Right(updatedProduct);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
