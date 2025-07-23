import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_item_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sale_item_api_model.g.dart';

@JsonSerializable()
class PopulatedProductInfoModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String? description;
  final String? category;

  const PopulatedProductInfoModel({
    required this.id,
    required this.name,
    this.description,
    this.category,
  });

  factory PopulatedProductInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PopulatedProductInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PopulatedProductInfoModelToJson(this);

  @override
  List<Object?> get props => [id, name, description, category];
}

@JsonSerializable()
class SaleItemApiModel extends Equatable {
  @JsonKey(name: 'product')
  final PopulatedProductInfoModel product;
  final String productName;
  final int quantity;
  final double priceAtSale;
  final double costAtSale;
  final double total;

  const SaleItemApiModel({
    required this.product,
    required this.productName,
    required this.quantity,
    required this.priceAtSale,
    required this.costAtSale,
    required this.total,
  });

  factory SaleItemApiModel.fromJson(Map<String, dynamic> json) {
    final productData = json['product'];
    PopulatedProductInfoModel populatedProduct;

    if (productData is Map<String, dynamic>) {
      populatedProduct = PopulatedProductInfoModel.fromJson(productData);
    } else if (productData is String) {
      populatedProduct = PopulatedProductInfoModel(
        id: productData,
        name: json['productName'] ?? 'Unknown',
      );
    } else {
      throw FormatException(
        "Invalid 'product' format in SaleItemApiModel: $productData",
      );
    }

    return SaleItemApiModel(
      product: populatedProduct,
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      priceAtSale: (json['priceAtSale'] as num).toDouble(),
      costAtSale: (json['costAtSale'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'productName': productName,
    'quantity': quantity,
    'priceAtSale': priceAtSale,
    'costAtSale': costAtSale,
    'total': total,
  };

  SaleItemEntity toEntity() {
    return SaleItemEntity(
      productId: product.id,
      productName: productName,
      quantity: quantity,
      priceAtSale: priceAtSale,
      costAtSale: costAtSale,
      total: total,
    );
  }

  @override
  List<Object?> get props => [
    product,
    productName,
    quantity,
    priceAtSale,
    costAtSale,
    total,
  ];
}
