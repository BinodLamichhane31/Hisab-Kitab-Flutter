import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_enums.dart';

abstract class SaleEvent extends Equatable {
  const SaleEvent();

  @override
  List<Object?> get props => [];
}

class LoadSalesEvent extends SaleEvent {
  final String shopId;
  final String? search;
  final String? customerId;
  final SaleType? saleType;

  const LoadSalesEvent({
    required this.shopId,
    this.search,
    this.customerId,
    this.saleType,
  });

  @override
  List<Object?> get props => [shopId, search, customerId, saleType];
}

class RefreshSalesEvent extends SaleEvent {
  final String shopId;
  final String? search;
  final String? customerId;
  final SaleType? saleType;

  const RefreshSalesEvent({
    required this.shopId,
    this.search,
    this.customerId,
    this.saleType,
  });

  @override
  List<Object?> get props => [shopId, search, customerId, saleType];
}

class CreateNewSaleEvent extends SaleEvent {
  final String shopId;
  final String? customerId;
  final List<({String productId, int quantity, double priceAtSale})> items;
  final double discount;
  final double tax;
  final double amountPaid;
  final String? notes;
  final DateTime? saleDate;

  const CreateNewSaleEvent({
    required this.shopId,
    this.customerId,
    required this.items,
    this.discount = 0.0,
    this.tax = 0.0,
    required this.amountPaid,
    this.notes,
    this.saleDate,
  });

  @override
  List<Object?> get props => [
    shopId,
    customerId,
    items,
    discount,
    tax,
    amountPaid,
    notes,
    saleDate,
  ];
}

class CancelSaleEvent extends SaleEvent {
  final String saleId;

  const CancelSaleEvent({required this.saleId});

  @override
  List<Object?> get props => [saleId];
}

class RecordSalePaymentEvent extends SaleEvent {
  final String saleId;
  final double amountPaid;
  final String? paymentMethod;

  const RecordSalePaymentEvent({
    required this.saleId,
    required this.amountPaid,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [saleId, amountPaid, paymentMethod];
}

class UpdateSaleInListEvent extends SaleEvent {
  final SaleEntity updatedSale;

  const UpdateSaleInListEvent(this.updatedSale);

  @override
  List<Object?> get props => [updatedSale];
}
