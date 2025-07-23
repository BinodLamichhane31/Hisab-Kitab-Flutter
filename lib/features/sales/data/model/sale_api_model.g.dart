// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopulatedCustomerInfoModel _$PopulatedCustomerInfoModelFromJson(
        Map<String, dynamic> json) =>
    PopulatedCustomerInfoModel(
      name: json['name'] as String,
      phone: json['phone'] as String?,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$PopulatedCustomerInfoModelToJson(
        PopulatedCustomerInfoModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      '_id': instance.id,
    };

PopulatedUserInfoModel _$PopulatedUserInfoModelFromJson(
        Map<String, dynamic> json) =>
    PopulatedUserInfoModel(
      fname: json['fname'] as String,
      lname: json['lname'] as String,
    );

Map<String, dynamic> _$PopulatedUserInfoModelToJson(
        PopulatedUserInfoModel instance) =>
    <String, dynamic>{
      'fname': instance.fname,
      'lname': instance.lname,
    };
