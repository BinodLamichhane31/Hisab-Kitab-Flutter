// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductApiModel _$ProductApiModelFromJson(Map<String, dynamic> json) =>
    ProductApiModel(
      productId: json['_id'] as String?,
      name: json['name'] as String,
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      category: json['category'] as String,
      description: json['description'] as String,
      reorderLevel: (json['reorderLevel'] as num).toInt(),
      shopId: json['shop'] as String,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ProductApiModelToJson(ProductApiModel instance) =>
    <String, dynamic>{
      '_id': instance.productId,
      'name': instance.name,
      'sellingPrice': instance.sellingPrice,
      'purchasePrice': instance.purchasePrice,
      'quantity': instance.quantity,
      'category': instance.category,
      'description': instance.description,
      'reorderLevel': instance.reorderLevel,
      'shop': instance.shopId,
      'image': instance.image,
    };
