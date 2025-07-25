// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelatedCustomerInfoModel _$RelatedCustomerInfoModelFromJson(
        Map<String, dynamic> json) =>
    RelatedCustomerInfoModel(
      name: json['name'] as String,
    );

Map<String, dynamic> _$RelatedCustomerInfoModelToJson(
        RelatedCustomerInfoModel instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

RelatedSupplierInfoModel _$RelatedSupplierInfoModelFromJson(
        Map<String, dynamic> json) =>
    RelatedSupplierInfoModel(
      name: json['name'] as String,
    );

Map<String, dynamic> _$RelatedSupplierInfoModelToJson(
        RelatedSupplierInfoModel instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

TransactionApiModel _$TransactionApiModelFromJson(Map<String, dynamic> json) =>
    TransactionApiModel(
      transactionId: json['_id'] as String,
      shopId: json['shop'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      category: $enumDecode(_$TransactionCategoryEnumMap, json['category']),
      amount: (json['amount'] as num).toDouble(),
      paymentMethod:
          $enumDecodeNullable(_$PaymentMethodEnumMap, json['paymentMethod']),
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      description: json['description'] as String?,
      relatedSale: json['relatedSale'] as String?,
      relatedPurchase: json['relatedPurchase'] as String?,
      relatedCustomer: json['relatedCustomer'] == null
          ? null
          : RelatedCustomerInfoModel.fromJson(
              json['relatedCustomer'] as Map<String, dynamic>),
      relatedSupplier: json['relatedSupplier'] == null
          ? null
          : RelatedSupplierInfoModel.fromJson(
              json['relatedSupplier'] as Map<String, dynamic>),
      createdBy: json['createdBy'] == null
          ? null
          : PopulatedUserInfoModel.fromJson(
              json['createdBy'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

const _$TransactionTypeEnumMap = {
  TransactionType.CASH_IN: 'CASH_IN',
  TransactionType.CASH_OUT: 'CASH_OUT',
};

const _$TransactionCategoryEnumMap = {
  TransactionCategory.SALE_PAYMENT: 'SALE_PAYMENT',
  TransactionCategory.PURCHASE_PAYMENT: 'PURCHASE_PAYMENT',
  TransactionCategory.EXPENSE_RENT: 'EXPENSE_RENT',
  TransactionCategory.EXPENSE_SALARY: 'EXPENSE_SALARY',
  TransactionCategory.EXPENSE_UTILITIES: 'EXPENSE_UTILITIES',
  TransactionCategory.OWNER_DRAWING: 'OWNER_DRAWING',
  TransactionCategory.CAPITAL_INJECTION: 'CAPITAL_INJECTION',
  TransactionCategory.OTHER_INCOME: 'OTHER_INCOME',
  TransactionCategory.OTHER_EXPENSE: 'OTHER_EXPENSE',
  TransactionCategory.SALE_RETURN: 'SALE_RETURN',
  TransactionCategory.PURCHASE_RETURN: 'PURCHASE_RETURN',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.CASH: 'CASH',
  PaymentMethod.BANK_TRANSFER: 'BANK_TRANSFER',
  PaymentMethod.CARD: 'CARD',
  PaymentMethod.CHEQUE: 'CHEQUE',
  PaymentMethod.CREDIT: 'CREDIT',
};
