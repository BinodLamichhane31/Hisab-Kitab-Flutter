import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_enums.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_item_entity.dart';

class PopulatedCustomerInfo extends Equatable {
  final String name;
  final String? phone;

  const PopulatedCustomerInfo({required this.name, this.phone});

  @override
  List<Object?> get props => [name, phone];
}

class PopulatedUserInfo extends Equatable {
  final String fname;
  final String lname;

  const PopulatedUserInfo({required this.fname, required this.lname});

  String get fullName => '$fname $lname';

  @override
  List<Object?> get props => [fname, lname];
}

class SaleEntity extends Equatable {
  final String? saleId;
  final String invoiceNumber;
  final String shopId;
  final String? customerId;
  final SaleType saleType;
  final List<SaleItemEntity> items;
  final double subTotal;
  final double discount;
  final double tax;
  final double grandTotal;
  final double amountPaid;
  final double amountDue;
  final PaymentStatus paymentStatus;
  final DateTime saleDate;
  final SaleStatus status;
  final String? notes;
  final PopulatedUserInfo? createdBy;
  final PopulatedCustomerInfo? customer;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SaleEntity({
    this.saleId,
    required this.invoiceNumber,
    required this.shopId,
    this.customerId,
    required this.saleType,
    required this.items,
    required this.subTotal,
    required this.discount,
    required this.tax,
    required this.grandTotal,
    required this.amountPaid,
    required this.amountDue,
    required this.paymentStatus,
    required this.saleDate,
    required this.status,
    this.notes,
    this.createdBy,
    this.customer,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    saleId,
    invoiceNumber,
    shopId,
    customerId,
    saleType,
    items,
    subTotal,
    discount,
    tax,
    grandTotal,
    amountPaid,
    amountDue,
    paymentStatus,
    saleDate,
    status,
    notes,
    createdBy,
    customer,
    createdAt,
    updatedAt,
  ];
}
