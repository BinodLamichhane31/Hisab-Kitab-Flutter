import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';
import 'package:hisab_kitab/features/products/domain/repository/product_repository.dart';

class AddProductParams extends Equatable {
  final String name;
  final double sellingPrice;
  final double purchasePrice;
  final int quantity;
  final String category;
  final String description;
  final int reorderLevel;
  final String shopId;
  final File? imageFile;

  const AddProductParams({
    required this.name,
    required this.sellingPrice,
    required this.purchasePrice,
    required this.quantity,
    required this.category,
    required this.description,
    required this.reorderLevel,
    required this.shopId,
    this.imageFile,
  });

  @override
  List<Object?> get props => [
    name,
    sellingPrice,
    purchasePrice,
    quantity,
    category,
    description,
    reorderLevel,
    shopId,
    imageFile,
  ];
}

class AddProductUsecase
    implements UseCaseWithParams<ProductEntity, AddProductParams> {
  final IProductRepository productRepository;

  AddProductUsecase({required this.productRepository});

  @override
  Future<Either<Failure, ProductEntity>> call(AddProductParams params) async {
    final productEntity = ProductEntity(
      name: params.name,
      sellingPrice: params.sellingPrice,
      purchasePrice: params.purchasePrice,
      quantity: params.quantity,
      category: params.category,
      description: params.description,
      reorderLevel: params.reorderLevel,
      shopId: params.shopId,
    );

    return await productRepository.addProduct(
      productEntity,
      imageFile: params.imageFile,
    );
  }
}
