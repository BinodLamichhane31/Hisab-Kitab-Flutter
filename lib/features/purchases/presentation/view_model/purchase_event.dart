import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_enums.dart';

abstract class PurchaseEvent extends Equatable {
  const PurchaseEvent();
  @override
  List<Object?> get props => [];
}

class LoadPurchasesEvent extends PurchaseEvent {
  final String shopId;
  final String? search;
  final String? supplierId;
  final PurchaseType? purchaseType;

  const LoadPurchasesEvent({
    required this.shopId,
    this.search,
    this.supplierId,
    this.purchaseType,
  });

  @override
  List<Object?> get props => [shopId, search, supplierId, purchaseType];
}

class RefreshPurchasesEvent extends PurchaseEvent {
  final String shopId;
  final String? search;
  final String? supplierId;
  final PurchaseType? purchaseType;

  const RefreshPurchasesEvent({
    required this.shopId,
    this.search,
    this.supplierId,
    this.purchaseType,
  });

  @override
  List<Object?> get props => [shopId, search, supplierId, purchaseType];
}
