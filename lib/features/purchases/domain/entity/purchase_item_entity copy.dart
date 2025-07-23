import 'package:equatable/equatable.dart';

class PurchaseItemEntity extends Equatable {
  final String productId;
  final String productName;
  final int quantity;
  final double unitCost;
  final double total;

  const PurchaseItemEntity({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitCost,
    required this.total,
  });

  @override
  List<Object?> get props => [
    productId,
    productName,
    quantity,
    unitCost,
    total,
  ];
}
