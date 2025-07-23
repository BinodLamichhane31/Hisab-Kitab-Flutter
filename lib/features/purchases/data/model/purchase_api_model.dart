import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/purchases/data/model/purchase_item_api_model.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_entity.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_enums.dart';
import 'package:hisab_kitab/features/sales/data/model/sale_api_model.dart'
    show PopulatedUserInfoModel;
import 'package:json_annotation/json_annotation.dart';

part 'purchase_api_model.g.dart';

const _$PurchaseTypeEnumMap = {
  PurchaseType.SUPPLIER: 'SUPPLIER',
  PurchaseType.CASH: 'CASH',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.PAID: 'PAID',
  PaymentStatus.PARTIAL: 'PARTIAL',
  PaymentStatus.UNPAID: 'UNPAID',
};

const _$PurchaseStatusEnumMap = {
  PurchaseStatus.COMPLETED: 'COMPLETED',
  PurchaseStatus.CANCELLED: 'CANCELLED',
};

@JsonSerializable()
class PopulatedSupplierInfoModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String? phone;

  const PopulatedSupplierInfoModel({
    required this.id,
    required this.name,
    this.phone,
  });

  factory PopulatedSupplierInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PopulatedSupplierInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$PopulatedSupplierInfoModelToJson(this);

  PopulatedSupplierInfo toEntity() =>
      PopulatedSupplierInfo(name: name, phone: phone);

  @override
  List<Object?> get props => [id, name, phone];
}

@JsonSerializable(createFactory: false, createToJson: false)
class PurchaseApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? purchaseId;
  final String billNumber;
  @JsonKey(name: 'shop')
  final String shopId;
  final String? supplierId;
  final PopulatedSupplierInfoModel? supplierInfo;
  final PurchaseType purchaseType;
  final List<PurchaseItemApiModel> items;
  final double subTotal;
  final double discount;
  final double grandTotal;
  final double amountPaid;
  final double amountDue;
  final PaymentStatus paymentStatus;
  final DateTime purchaseDate;
  final PurchaseStatus status;
  final String? notes;
  @JsonKey(name: 'createdBy')
  final PopulatedUserInfoModel? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PurchaseApiModel({
    this.purchaseId,
    required this.billNumber,
    required this.shopId,
    this.supplierId,
    this.supplierInfo,
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
    this.createdAt,
    this.updatedAt,
  });

  factory PurchaseApiModel.fromJson(Map<String, dynamic> json) {
    String? parsedSupplierId;
    PopulatedSupplierInfoModel? parsedSupplierInfo;
    final supplierData = json['supplier'];
    if (supplierData is String) {
      parsedSupplierId = supplierData;
    } else if (supplierData is Map<String, dynamic>) {
      parsedSupplierInfo = PopulatedSupplierInfoModel.fromJson(supplierData);
      parsedSupplierId = parsedSupplierInfo.id;
    }

    return PurchaseApiModel(
      purchaseId: json['_id'],
      billNumber: json['billNumber'],
      shopId: json['shop'],
      supplierId: parsedSupplierId,
      supplierInfo: parsedSupplierInfo,
      purchaseType: $enumDecode(_$PurchaseTypeEnumMap, json['purchaseType']),
      items:
          (json['items'] as List)
              .map(
                (i) => PurchaseItemApiModel.fromJson(i as Map<String, dynamic>),
              )
              .toList(),
      subTotal: (json['subTotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      amountPaid: (json['amountPaid'] as num).toDouble(),
      amountDue: (json['amountDue'] as num).toDouble(),
      paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      status: $enumDecode(_$PurchaseStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      createdBy:
          json['createdBy'] != null
              ? PopulatedUserInfoModel.fromJson(
                json['createdBy'] as Map<String, dynamic>,
              )
              : null,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': purchaseId,
      'billNumber': billNumber,
      'shop': shopId,
      'supplier': supplierId,
      'purchaseType': _$PurchaseTypeEnumMap[purchaseType],
      'items': items.map((item) => item.toJson()).toList(),
      'subTotal': subTotal,
      'discount': discount,
      'grandTotal': grandTotal,
      'amountPaid': amountPaid,
      'amountDue': amountDue,
      'paymentStatus': _$PaymentStatusEnumMap[paymentStatus],
      'purchaseDate': purchaseDate.toIso8601String(),
      'status': _$PurchaseStatusEnumMap[status],
      'notes': notes,
    };
  }

  PurchaseEntity toEntity() {
    return PurchaseEntity(
      purchaseId: purchaseId,
      billNumber: billNumber,
      shopId: shopId,
      supplierId: supplierId,
      supplier: supplierInfo?.toEntity(),
      purchaseType: purchaseType,
      items: items.map((item) => item.toEntity()).toList(),
      subTotal: subTotal,
      discount: discount,
      grandTotal: grandTotal,
      amountPaid: amountPaid,
      amountDue: amountDue,
      paymentStatus: paymentStatus,
      purchaseDate: purchaseDate,
      status: status,
      notes: notes,
      createdBy: createdBy?.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static List<PurchaseEntity> toEntityList(List<PurchaseApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
    purchaseId,
    billNumber,
    shopId,
    supplierId,
    supplierInfo,
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
    createdAt,
    updatedAt,
  ];
}
