import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/chart_data_point_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chart_data_point_api_model.g.dart';

@JsonSerializable()
class ChartDataPointApiModel extends Equatable {
  final String name;
  final double sales;
  final double purchases;

  const ChartDataPointApiModel({
    required this.name,
    required this.sales,
    required this.purchases,
  });

  factory ChartDataPointApiModel.fromJson(Map<String, dynamic> json) =>
      _$ChartDataPointApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChartDataPointApiModelToJson(this);

  ChartDataPointEntity toEntity() {
    return ChartDataPointEntity(name: name, sales: sales, purchases: purchases);
  }

  factory ChartDataPointApiModel.fromEntity(ChartDataPointEntity entity) {
    return ChartDataPointApiModel(
      name: entity.name,
      sales: entity.sales,
      purchases: entity.purchases,
    );
  }

  static List<ChartDataPointEntity> toEntityList(
    List<ChartDataPointApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [name, sales, purchases];
}
