import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_item_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sale_item_api_model.g.dart';

@JsonSerializable()
class SaleItemApiModel extends Equatable {
  @JsonKey(name: 'product')
  final String productId;
  final String productName;
  final int quantity;
  final double priceAtSale;
  final double costAtSale;
  final double total;

  const SaleItemApiModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.priceAtSale,
    required this.costAtSale,
    required this.total,
  });

  factory SaleItemApiModel.fromJson(Map<String, dynamic> json) =>
      _$SaleItemApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaleItemApiModelToJson(this);

  SaleItemEntity toEntity() {
    return SaleItemEntity(
      productId: productId,
      productName: productName,
      quantity: quantity,
      priceAtSale: priceAtSale,
      costAtSale: costAtSale,
      total: total,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    productName,
    quantity,
    priceAtSale,
    costAtSale,
    total,
  ];
}
