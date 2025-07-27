import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_enums.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart'
    show PopulatedUserInfo;

class RelatedCustomerInfo extends Equatable {
  final String name;
  const RelatedCustomerInfo({required this.name});
  @override
  List<Object?> get props => [name];
}

class RelatedSupplierInfo extends Equatable {
  final String name;
  const RelatedSupplierInfo({required this.name});
  @override
  List<Object?> get props => [name];
}

class TransactionEntity extends Equatable {
  final String transactionId;
  final String shopId;
  final TransactionType type;
  final TransactionCategory category;
  final double amount;
  final PaymentMethod? paymentMethod;
  final DateTime transactionDate;
  final String? description;
  final String? relatedSaleId;
  final String? relatedPurchaseId;
  final RelatedCustomerInfo? relatedCustomer;
  final RelatedSupplierInfo? relatedSupplier;
  final PopulatedUserInfo? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TransactionEntity({
    required this.transactionId,
    required this.shopId,
    required this.type,
    required this.category,
    required this.amount,
    this.paymentMethod,
    required this.transactionDate,
    this.description,
    this.relatedSaleId,
    this.relatedPurchaseId,
    this.relatedCustomer,
    this.relatedSupplier,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    transactionId,
    shopId,
    type,
    category,
    amount,
    paymentMethod,
    transactionDate,
    description,
    relatedSaleId,
    relatedPurchaseId,
    relatedCustomer,
    relatedSupplier,
    createdBy,
    createdAt,
    updatedAt,
  ];
}
