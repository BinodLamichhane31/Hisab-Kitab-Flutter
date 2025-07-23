import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';

abstract class CreateSaleEvent extends Equatable {
  const CreateSaleEvent();
  @override
  List<Object?> get props => [];
}

class ToggleSaleType extends CreateSaleEvent {
  final bool isCashSale;
  const ToggleSaleType(this.isCashSale);
}

class CustomerSelected extends CreateSaleEvent {
  final CustomerEntity customer;
  const CustomerSelected(this.customer);
}

class ProductsAdded extends CreateSaleEvent {
  final List<ProductEntity> products;
  const ProductsAdded(this.products);
}

class ItemRemoved extends CreateSaleEvent {
  final String productId;
  const ItemRemoved(this.productId);
}

class ItemQuantityChanged extends CreateSaleEvent {
  final String productId;
  final int newQuantity;
  const ItemQuantityChanged(this.productId, this.newQuantity);
}

class ItemPriceChanged extends CreateSaleEvent {
  final String productId;
  final double newPrice;
  const ItemPriceChanged(this.productId, this.newPrice);
}

class FieldChanged extends CreateSaleEvent {
  final double? discount;
  final double? tax;
  final double? amountPaid;
  final String? notes;
  final DateTime? saleDate;

  const FieldChanged({
    this.discount,
    this.tax,
    this.amountPaid,
    this.notes,
    this.saleDate,
  });
}

class SubmitSale extends CreateSaleEvent {}
