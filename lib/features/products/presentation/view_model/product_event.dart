import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductEvent {
  final String shopId;
  final int? page;
  final int? limit;
  final String? search;

  const LoadProductsEvent({
    required this.shopId,
    this.page,
    this.limit,
    this.search,
  });

  @override
  List<Object?> get props => [shopId, page, limit, search];
}

class RefreshProductsEvent extends ProductEvent {
  final String shopId;
  final String? search;

  const RefreshProductsEvent({required this.shopId, this.search});

  @override
  List<Object?> get props => [shopId, search];
}

// Event to update a single product in the list locally
class UpdateProductInListEvent extends ProductEvent {
  final ProductEntity updatedProduct;

  const UpdateProductInListEvent(this.updatedProduct);

  @override
  List<Object?> get props => [updatedProduct];
}

// Event to remove a single product from the list locally
class DeleteProductFromListEvent extends ProductEvent {
  final String productId;

  const DeleteProductFromListEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class AddNewProductEvent extends ProductEvent {
  final String name;
  final double sellingPrice;
  final double purchasePrice;
  final int quantity;
  final String category;
  final String description;
  final int reorderLevel;
  final String shopId;
  final File? imageFile;

  const AddNewProductEvent({
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
