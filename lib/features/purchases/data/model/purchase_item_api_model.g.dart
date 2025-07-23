// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_item_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseItemApiModel _$PurchaseItemApiModelFromJson(
        Map<String, dynamic> json) =>
    PurchaseItemApiModel(
      product: PopulatedProductInfoModel.fromJson(
          json['product'] as Map<String, dynamic>),
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitCost: (json['unitCost'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$PurchaseItemApiModelToJson(
        PurchaseItemApiModel instance) =>
    <String, dynamic>{
      'product': instance.product,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'unitCost': instance.unitCost,
      'total': instance.total,
    };
