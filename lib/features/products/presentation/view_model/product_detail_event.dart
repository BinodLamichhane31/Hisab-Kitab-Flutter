import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the details of a specific product.
class LoadProductDetailEvent extends ProductDetailEvent {
  final String productId;

  const LoadProductDetailEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/// Event to update an existing product's details.
class UpdateProductEvent extends ProductDetailEvent {
  final ProductEntity product;
  final File? imageFile;

  const UpdateProductEvent({required this.product, this.imageFile});

  @override
  List<Object?> get props => [product, imageFile];
}

/// Event to delete a product.
class DeleteProductEvent extends ProductDetailEvent {
  final String productId;

  const DeleteProductEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}
