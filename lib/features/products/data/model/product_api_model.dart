// lib/features/products/data/model/product_api_model.dart

import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_api_model.g.dart';

@JsonSerializable()
class ProductApiModel extends Equatable {
  @JsonKey(name: '_id')
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

  const ProductApiModel({
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
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProductApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductApiModelToJson(this);

  factory ProductApiModel.fromEntity(ProductEntity entity) {
    return ProductApiModel(
      productId: entity.productId,
      name: entity.name,
      sellingPrice: entity.sellingPrice,
      purchasePrice: entity.purchasePrice,
      quantity: entity.quantity,
      category: entity.category,
      description: entity.description,
      reorderLevel: entity.reorderLevel,
      shopId: entity.shopId,
      image: entity.image,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      productId: productId,
      name: name,
      sellingPrice: sellingPrice,
      purchasePrice: purchasePrice,
      quantity: quantity,
      category: category,
      description: description,
      reorderLevel: reorderLevel,
      shopId: shopId,
      image: image,
    );
  }

  static List<ProductEntity> toEntityList(List<ProductApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  static List<ProductApiModel> fromEntityList(List<ProductEntity> entities) {
    return entities
        .map((entity) => ProductApiModel.fromEntity(entity))
        .toList();
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
  ];
}
