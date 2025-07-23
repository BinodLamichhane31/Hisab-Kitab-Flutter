import 'package:equatable/equatable.dart';

class SaleItemEntity extends Equatable {
  final String productId;
  final String productName;
  final int quantity;
  final double priceAtSale;
  final double costAtSale;
  final double total;

  const SaleItemEntity({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.priceAtSale,
    required this.costAtSale,
    required this.total,
  });

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
