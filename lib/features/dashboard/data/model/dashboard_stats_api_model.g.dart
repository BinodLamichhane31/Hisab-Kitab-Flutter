// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStatsApiModel _$DashboardStatsApiModelFromJson(
        Map<String, dynamic> json) =>
    DashboardStatsApiModel(
      totalCustomers: (json['totalCustomers'] as num).toInt(),
      totalSuppliers: (json['totalSuppliers'] as num).toInt(),
      receivableAmount: (json['receivableAmount'] as num).toDouble(),
      payableAmount: (json['payableAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$DashboardStatsApiModelToJson(
        DashboardStatsApiModel instance) =>
    <String, dynamic>{
      'totalCustomers': instance.totalCustomers,
      'totalSuppliers': instance.totalSuppliers,
      'receivableAmount': instance.receivableAmount,
      'payableAmount': instance.payableAmount,
    };
