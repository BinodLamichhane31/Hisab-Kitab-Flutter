// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerApiModel _$CustomerApiModelFromJson(Map<String, dynamic> json) =>
    CustomerApiModel(
      customerId: json['_id'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      currentBalance: (json['currentBalance'] as num).toDouble(),
      shopId: json['shop'] as String,
    );

Map<String, dynamic> _$CustomerApiModelToJson(CustomerApiModel instance) =>
    <String, dynamic>{
      '_id': instance.customerId,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'currentBalance': instance.currentBalance,
      'shop': instance.shopId,
    };
