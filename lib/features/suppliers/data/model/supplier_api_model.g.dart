// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierApiModel _$SupplierApiModelFromJson(Map<String, dynamic> json) =>
    SupplierApiModel(
      supplierId: json['_id'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      currentBalance: (json['currentBalance'] as num).toDouble(),
      totalSupplied: (json['totalSupplied'] as num).toDouble(),
      shopId: json['shop'] as String,
    );

Map<String, dynamic> _$SupplierApiModelToJson(SupplierApiModel instance) =>
    <String, dynamic>{
      '_id': instance.supplierId,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'currentBalance': instance.currentBalance,
      'totalSupplied': instance.totalSupplied,
      'shop': instance.shopId,
    };
