import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/sales/data/model/sale_item_api_model.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sale_api_model.g.dart';

@JsonSerializable()
class PopulatedCustomerInfoModel extends Equatable {
  final String name;
  final String? phone;
  @JsonKey(name: '_id')
  final String id;

  const PopulatedCustomerInfoModel({
    required this.name,
    this.phone,
    required this.id,
  });

  factory PopulatedCustomerInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PopulatedCustomerInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$PopulatedCustomerInfoModelToJson(this);

  PopulatedCustomerInfo toEntity() =>
      PopulatedCustomerInfo(name: name, phone: phone);

  @override
  List<Object?> get props => [name, phone, id];
}

@JsonSerializable()
class PopulatedUserInfoModel extends Equatable {
  final String fname;
  final String lname;

  const PopulatedUserInfoModel({required this.fname, required this.lname});

  factory PopulatedUserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PopulatedUserInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$PopulatedUserInfoModelToJson(this);

  PopulatedUserInfo toEntity() => PopulatedUserInfo(fname: fname, lname: lname);

  @override
  List<Object?> get props => [fname, lname];
}

@JsonSerializable(createFactory: false)
class SaleApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? saleId;
  final String invoiceNumber;
  @JsonKey(name: 'shop')
  final String shopId;
  final String? customerId;
  final PopulatedCustomerInfoModel? customerInfo;
  final SaleType saleType;
  final List<SaleItemApiModel> items;
  final double subTotal;
  final double? discount;
  final double? tax;
  final double grandTotal;
  final double amountPaid;
  final double amountDue;
  final PaymentStatus paymentStatus;
  final DateTime saleDate;
  final SaleStatus status;
  final String? notes;
  @JsonKey(name: 'createdBy')
  final PopulatedUserInfoModel? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SaleApiModel({
    this.saleId,
    required this.invoiceNumber,
    required this.shopId,
    this.customerId,
    this.customerInfo,
    required this.saleType,
    required this.items,
    required this.subTotal,
    this.discount,
    this.tax,
    required this.grandTotal,
    required this.amountPaid,
    required this.amountDue,
    required this.paymentStatus,
    required this.saleDate,
    required this.status,
    this.notes,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory SaleApiModel.fromJson(Map<String, dynamic> json) {
    String? parsedCustomerId;
    PopulatedCustomerInfoModel? parsedCustomerInfo;

    final customerData = json['customer'];
    if (customerData is String) {
      parsedCustomerId = customerData;
    } else if (customerData is Map<String, dynamic>) {
      parsedCustomerInfo = PopulatedCustomerInfoModel.fromJson(customerData);
      parsedCustomerId = parsedCustomerInfo.id;
    }

    return SaleApiModel(
      saleId: json['_id'],
      invoiceNumber: json['invoiceNumber'],
      shopId: json['shop'],
      customerId: parsedCustomerId,
      customerInfo: parsedCustomerInfo,
      saleType: $enumDecode(_$SaleTypeEnumMap, json['saleType']),
      items:
          (json['items'] as List<dynamic>)
              .map((e) => SaleItemApiModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      subTotal: (json['subTotal'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      amountPaid: (json['amountPaid'] as num).toDouble(),
      amountDue: (json['amountDue'] as num).toDouble(),
      paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
      saleDate: DateTime.parse(json['saleDate'] as String),
      status: $enumDecode(_$SaleStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      createdBy:
          json['createdBy'] == null
              ? null
              : PopulatedUserInfoModel.fromJson(
                json['createdBy'] as Map<String, dynamic>,
              ),
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

  Map<String, dynamic> toJson() => _$SaleApiModelToJson(this);

  SaleEntity toEntity() {
    return SaleEntity(
      saleId: saleId,
      invoiceNumber: invoiceNumber,
      shopId: shopId,
      customerId: customerId,
      customer: customerInfo?.toEntity(),
      saleType: saleType,
      items: items.map((item) => item.toEntity()).toList(),
      subTotal: subTotal,
      discount: discount ?? 0,
      tax: tax ?? 0,
      grandTotal: grandTotal,
      amountPaid: amountPaid,
      amountDue: amountDue,
      paymentStatus: paymentStatus,
      saleDate: saleDate,
      status: status,
      notes: notes,
      createdBy: createdBy?.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static List<SaleEntity> toEntityList(List<SaleApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
    saleId,
    invoiceNumber,
    shopId,
    customerId,
    customerInfo,
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
    createdAt,
    updatedAt,
  ];
}
