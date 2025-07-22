// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_item_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopulatedProductInfoModel _$PopulatedProductInfoModelFromJson(
        Map<String, dynamic> json) =>
    PopulatedProductInfoModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$PopulatedProductInfoModelToJson(
        PopulatedProductInfoModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
    };

SaleItemApiModel _$SaleItemApiModelFromJson(Map<String, dynamic> json) =>
    SaleItemApiModel(
      product: PopulatedProductInfoModel.fromJson(
          json['product'] as Map<String, dynamic>),
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      priceAtSale: (json['priceAtSale'] as num).toDouble(),
      costAtSale: (json['costAtSale'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$SaleItemApiModelToJson(SaleItemApiModel instance) =>
    <String, dynamic>{
      'product': instance.product,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'priceAtSale': instance.priceAtSale,
      'costAtSale': instance.costAtSale,
      'total': instance.total,
    };
