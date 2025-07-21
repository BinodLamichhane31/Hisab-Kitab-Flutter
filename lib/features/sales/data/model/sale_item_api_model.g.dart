// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_item_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleItemApiModel _$SaleItemApiModelFromJson(Map<String, dynamic> json) =>
    SaleItemApiModel(
      productId: json['product'] as String,
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      priceAtSale: (json['priceAtSale'] as num).toDouble(),
      costAtSale: (json['costAtSale'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$SaleItemApiModelToJson(SaleItemApiModel instance) =>
    <String, dynamic>{
      'product': instance.productId,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'priceAtSale': instance.priceAtSale,
      'costAtSale': instance.costAtSale,
      'total': instance.total,
    };
