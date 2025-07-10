// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopApiModel _$ShopApiModelFromJson(Map<String, dynamic> json) => ShopApiModel(
      shopId: json['_id'] as String?,
      shopName: json['name'] as String,
      address: json['address'] as String?,
      contactNumber: json['contactNumber'] as String?,
      owner: ShopOwnerApiModel.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShopApiModelToJson(ShopApiModel instance) =>
    <String, dynamic>{
      '_id': instance.shopId,
      'name': instance.shopName,
      'address': instance.address,
      'contactNumber': instance.contactNumber,
      'owner': instance.owner,
    };

ShopOwnerApiModel _$ShopOwnerApiModelFromJson(Map<String, dynamic> json) =>
    ShopOwnerApiModel(
      ownerId: json['_id'] as String,
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$ShopOwnerApiModelToJson(ShopOwnerApiModel instance) =>
    <String, dynamic>{
      '_id': instance.ownerId,
      'fname': instance.fname,
      'lname': instance.lname,
      'email': instance.email,
    };
