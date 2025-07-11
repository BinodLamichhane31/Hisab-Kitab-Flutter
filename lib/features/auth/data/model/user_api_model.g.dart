// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
      userId: json['_id'] as String?,
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      shops: json['shops'] == null ? const [] : _shopsFromJson(json['shops']),
      activeShop: _activeShopFromJson(json['activeShop']),
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'fname': instance.fname,
      'lname': instance.lname,
      'phone': instance.phone,
      'email': instance.email,
      'password': instance.password,
      'shops': _shopsToJson(instance.shops),
      'activeShop': _activeShopToJson(instance.activeShop),
    };
