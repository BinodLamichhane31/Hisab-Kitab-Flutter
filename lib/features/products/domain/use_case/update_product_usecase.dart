import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';
import 'package:hisab_kitab/features/products/domain/repository/product_repository.dart';

class UpdateProductParams extends Equatable {
  final ProductEntity product;
  final File? imageFile; // Pass new image file for update

  const UpdateProductParams({required this.product, this.imageFile});

  @override
  List<Object?> get props => [product, imageFile];
}

class UpdateProductUsecase
    implements UseCaseWithParams<ProductEntity, UpdateProductParams> {
  final IProductRepository productRepository;

  UpdateProductUsecase({required this.productRepository});

  @override
  Future<Either<Failure, ProductEntity>> call(UpdateProductParams params) {
    return productRepository.updateProduct(
      params.product,
      imageFile: params.imageFile,
    );
  }
}
