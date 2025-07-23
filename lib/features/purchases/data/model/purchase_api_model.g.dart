// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopulatedSupplierInfoModel _$PopulatedSupplierInfoModelFromJson(
        Map<String, dynamic> json) =>
    PopulatedSupplierInfoModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$PopulatedSupplierInfoModelToJson(
        PopulatedSupplierInfoModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
    };
