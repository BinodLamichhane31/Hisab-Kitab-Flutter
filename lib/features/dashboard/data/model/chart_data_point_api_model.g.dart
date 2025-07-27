// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_data_point_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartDataPointApiModel _$ChartDataPointApiModelFromJson(
        Map<String, dynamic> json) =>
    ChartDataPointApiModel(
      name: json['name'] as String,
      sales: (json['sales'] as num).toDouble(),
      purchases: (json['purchases'] as num).toDouble(),
    );

Map<String, dynamic> _$ChartDataPointApiModelToJson(
        ChartDataPointApiModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sales': instance.sales,
      'purchases': instance.purchases,
    };
