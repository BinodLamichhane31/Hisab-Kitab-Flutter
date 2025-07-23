import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_enums.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_item_entity%20copy.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart'
    show PopulatedUserInfo;

class PopulatedSupplierInfo extends Equatable {
  final String name;
  final String? phone;

  const PopulatedSupplierInfo({required this.name, this.phone});

  @override
  List<Object?> get props => [name, phone];
}

class PurchaseEntity extends Equatable {
  final String? purchaseId;
  final String billNumber;
  final String shopId;
  final String? supplierId;
  final PurchaseType purchaseType;
  final List<PurchaseItemEntity> items;
  final double subTotal;
  final double discount;
  final double grandTotal;
  final double amountPaid;
  final double amountDue;
  final PaymentStatus paymentStatus;
  final DateTime purchaseDate;
  final PurchaseStatus status;
  final String? notes;
  final PopulatedUserInfo? createdBy;
  final PopulatedSupplierInfo? supplier;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PurchaseEntity({
    this.purchaseId,
    required this.billNumber,
    required this.shopId,
    this.supplierId,
    required this.purchaseType,
    required this.items,
    required this.subTotal,
    required this.discount,
    required this.grandTotal,
    required this.amountPaid,
    required this.amountDue,
    required this.paymentStatus,
    required this.purchaseDate,
    required this.status,
    this.notes,
    this.createdBy,
    this.supplier,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    purchaseId,
    billNumber,
    shopId,
    supplierId,
    purchaseType,
    items,
    subTotal,
    discount,
    grandTotal,
    amountPaid,
    amountDue,
    paymentStatus,
    purchaseDate,
    status,
    notes,
    createdBy,
    supplier,
    createdAt,
    updatedAt,
  ];
}
