import 'dart:io';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? productId;
  final String name;
  final double sellingPrice;
  final double purchasePrice;
  final int quantity;
  final String category;
  final String description;
  final int reorderLevel;
  final String shopId;
  final String? image;
  final File? imageFile;

  const ProductEntity({
    this.productId,
    required this.name,
    required this.sellingPrice,
    required this.purchasePrice,
    required this.quantity,
    required this.category,
    required this.description,
    required this.reorderLevel,
    required this.shopId,
    this.image,
    this.imageFile,
  });

  ProductEntity copyWith({
    String? productId,
    String? name,
    double? sellingPrice,
    double? purchasePrice,
    int? quantity,
    String? category,
    String? description,
    int? reorderLevel,
    String? shopId,
    String? image,
    File? imageFile,
    bool clearImage = false,
  }) {
    return ProductEntity(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      description: description ?? this.description,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      shopId: shopId ?? this.shopId,
      image: clearImage ? null : image ?? this.image,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    sellingPrice,
    purchasePrice,
    quantity,
    category,
    description,
    reorderLevel,
    shopId,
    image,
    imageFile,
  ];
}
