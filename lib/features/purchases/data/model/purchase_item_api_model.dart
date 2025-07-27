import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_item_entity%20copy.dart';
import 'package:hisab_kitab/features/sales/data/model/sale_item_api_model.dart'
    show PopulatedProductInfoModel;
import 'package:json_annotation/json_annotation.dart';

part 'purchase_item_api_model.g.dart';

@JsonSerializable()
class PurchaseItemApiModel extends Equatable {
  @JsonKey(name: 'product')
  final PopulatedProductInfoModel product;
  final String productName;
  final int quantity;
  final double unitCost;
  final double total;

  const PurchaseItemApiModel({
    required this.product,
    required this.productName,
    required this.quantity,
    required this.unitCost,
    required this.total,
  });

  factory PurchaseItemApiModel.fromJson(Map<String, dynamic> json) {
    try {
      final productData = json['product'];
      PopulatedProductInfoModel populatedProduct;

      if (productData is Map<String, dynamic>) {
        populatedProduct = PopulatedProductInfoModel.fromJson(productData);
      } else if (productData is String) {
        // If we only get the product ID, create a minimal model.
        // The productName from the parent object is crucial here.
        populatedProduct = PopulatedProductInfoModel(
          id: productData,
          name: json['productName'] ?? 'Unknown Product',
        );
      } else {
        // This case should be rare, but it's good to have a fallback.
        throw FormatException(
          "Invalid 'product' format in PurchaseItemApiModel: $productData",
        );
      }

      return PurchaseItemApiModel(
        product: populatedProduct,
        productName: json['productName'] as String,
        quantity: (json['quantity'] as num).toInt(),
        unitCost: (json['unitCost'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
      );
    } catch (e) {
      print("==== FAILED TO PARSE PurchaseItemApiModel ====");
      print("Error: $e");
      print("Problematic JSON: $json");
      print("========================================");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'product': product.id, // When sending data, just send the ID.
    'productName': productName,
    'quantity': quantity,
    'unitCost': unitCost,
    'total': total,
  };

  PurchaseItemEntity toEntity() {
    return PurchaseItemEntity(
      productId: product.id,
      productName: productName,
      quantity: quantity,
      unitCost: unitCost,
      total: total,
    );
  }

  @override
  List<Object?> get props => [product, productName, quantity, unitCost, total];
}
