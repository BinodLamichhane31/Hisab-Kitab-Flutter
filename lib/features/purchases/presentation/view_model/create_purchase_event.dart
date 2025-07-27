import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';

abstract class CreatePurchaseEvent extends Equatable {
  const CreatePurchaseEvent();
  @override
  List<Object?> get props => [];
}

class TogglePurchaseType extends CreatePurchaseEvent {
  final bool isCashPurchase;
  const TogglePurchaseType(this.isCashPurchase);
}

class SupplierSelected extends CreatePurchaseEvent {
  final SupplierEntity supplier;
  const SupplierSelected(this.supplier);
}

class ProductsAdded extends CreatePurchaseEvent {
  final List<ProductEntity> products;
  const ProductsAdded(this.products);
}

class ItemRemoved extends CreatePurchaseEvent {
  final String productId;
  const ItemRemoved(this.productId);
}

class ItemQuantityChanged extends CreatePurchaseEvent {
  final String productId;
  final int newQuantity;
  const ItemQuantityChanged(this.productId, this.newQuantity);
}

class ItemCostChanged extends CreatePurchaseEvent {
  final String productId;
  final double newCost;
  const ItemCostChanged(this.productId, this.newCost);
}

class FieldChanged extends CreatePurchaseEvent {
  final double? discount;
  final double? amountPaid;
  final String? notes;
  final String? billNumber;
  final DateTime? purchaseDate;

  const FieldChanged({
    this.discount,
    this.amountPaid,
    this.notes,
    this.billNumber,
    this.purchaseDate,
  });
}

class SubmitPurchase extends CreatePurchaseEvent {}
