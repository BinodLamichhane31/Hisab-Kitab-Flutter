import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProductFormEvent extends Equatable {
  const ProductFormEvent();
}

class SubmitProductFormEvent extends ProductFormEvent {
  // If productId is null, it's a new product. Otherwise, it's an update.
  final String? productId;
  final String shopId;
  final String name;
  final double sellingPrice;
  final double purchasePrice;
  final int quantity;
  final String category;
  final String description;
  final int reorderLevel;
  final File? imageFile;
  final String? existingImageUrl;

  const SubmitProductFormEvent({
    this.productId,
    required this.shopId,
    required this.name,
    required this.sellingPrice,
    required this.purchasePrice,
    required this.quantity,
    required this.category,
    required this.description,
    required this.reorderLevel,
    this.imageFile,
    this.existingImageUrl,
  });

  @override
  List<Object?> get props => [
    productId,
    shopId,
    name,
    sellingPrice,
    purchasePrice,
    quantity,
    category,
    description,
    reorderLevel,
    imageFile,
    existingImageUrl,
  ];
}
