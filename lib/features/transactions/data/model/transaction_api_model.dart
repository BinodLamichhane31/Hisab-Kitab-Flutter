import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/sales/data/model/sale_api_model.dart'
    show PopulatedUserInfoModel;
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_entity.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_api_model.g.dart';

@JsonSerializable()
class RelatedCustomerInfoModel extends Equatable {
  final String name;
  const RelatedCustomerInfoModel({required this.name});

  factory RelatedCustomerInfoModel.fromJson(Map<String, dynamic> json) =>
      _$RelatedCustomerInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$RelatedCustomerInfoModelToJson(this);

  RelatedCustomerInfo toEntity() => RelatedCustomerInfo(name: name);
  @override
  List<Object?> get props => [name];
}

@JsonSerializable()
class RelatedSupplierInfoModel extends Equatable {
  final String name;
  const RelatedSupplierInfoModel({required this.name});

  factory RelatedSupplierInfoModel.fromJson(Map<String, dynamic> json) =>
      _$RelatedSupplierInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$RelatedSupplierInfoModelToJson(this);

  RelatedSupplierInfo toEntity() => RelatedSupplierInfo(name: name);
  @override
  List<Object?> get props => [name];
}

@JsonSerializable(createToJson: false)
class TransactionApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String transactionId;
  @JsonKey(name: 'shop')
  final String shopId;
  final TransactionType type;
  final TransactionCategory category;
  final double amount;
  final PaymentMethod? paymentMethod;
  final DateTime transactionDate;
  final String? description;
  final String? relatedSale;
  final String? relatedPurchase;
  final RelatedCustomerInfoModel? relatedCustomer;
  final RelatedSupplierInfoModel? relatedSupplier;
  final PopulatedUserInfoModel? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TransactionApiModel({
    required this.transactionId,
    required this.shopId,
    required this.type,
    required this.category,
    required this.amount,
    this.paymentMethod,
    required this.transactionDate,
    this.description,
    this.relatedSale,
    this.relatedPurchase,
    this.relatedCustomer,
    this.relatedSupplier,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory TransactionApiModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionApiModelFromJson(json);

  TransactionEntity toEntity() {
    return TransactionEntity(
      transactionId: transactionId,
      shopId: shopId,
      type: type,
      category: category,
      amount: amount,
      paymentMethod: paymentMethod,
      transactionDate: transactionDate,
      description: description,
      relatedSaleId: relatedSale,
      relatedPurchaseId: relatedPurchase,
      relatedCustomer: relatedCustomer?.toEntity(),
      relatedSupplier: relatedSupplier?.toEntity(),
      createdBy: createdBy?.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static List<TransactionEntity> toEntityList(
    List<TransactionApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }

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
    relatedSale,
    relatedPurchase,
    relatedCustomer,
    relatedSupplier,
    createdBy,
    createdAt,
    updatedAt,
  ];
}
