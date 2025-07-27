import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/dashboard_stats_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats_api_model.g.dart';

@JsonSerializable()
class DashboardStatsApiModel extends Equatable {
  final int totalCustomers;
  final int totalSuppliers;
  final double receivableAmount;
  final double payableAmount;

  const DashboardStatsApiModel({
    required this.totalCustomers,
    required this.totalSuppliers,
    required this.receivableAmount,
    required this.payableAmount,
  });

  factory DashboardStatsApiModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsApiModelToJson(this);

  /// Converts the Data Transfer Object (API Model) to a Domain Entity.
  DashboardStatsEntity toEntity() {
    return DashboardStatsEntity(
      totalCustomers: totalCustomers,
      totalSuppliers: totalSuppliers,
      receivableAmount: receivableAmount,
      payableAmount: payableAmount,
    );
  }

  /// Creates an API Model from a Domain Entity.
  /// (Useful if you were to send this data to the server).
  factory DashboardStatsApiModel.fromEntity(DashboardStatsEntity entity) {
    return DashboardStatsApiModel(
      totalCustomers: entity.totalCustomers,
      totalSuppliers: entity.totalSuppliers,
      receivableAmount: entity.receivableAmount,
      payableAmount: entity.payableAmount,
    );
  }

  @override
  List<Object?> get props => [
    totalCustomers,
    totalSuppliers,
    receivableAmount,
    payableAmount,
  ];
}
