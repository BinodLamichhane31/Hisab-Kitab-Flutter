// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_shops_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllShopsDto _$GetAllShopsDtoFromJson(Map<String, dynamic> json) =>
    GetAllShopsDto(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => ShopApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllShopsDtoToJson(GetAllShopsDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
