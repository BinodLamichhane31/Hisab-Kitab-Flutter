// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopulatedCustomerInfoModel _$PopulatedCustomerInfoModelFromJson(
        Map<String, dynamic> json) =>
    PopulatedCustomerInfoModel(
      name: json['name'] as String,
      phone: json['phone'] as String?,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$PopulatedCustomerInfoModelToJson(
        PopulatedCustomerInfoModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      '_id': instance.id,
    };

PopulatedUserInfoModel _$PopulatedUserInfoModelFromJson(
        Map<String, dynamic> json) =>
    PopulatedUserInfoModel(
      fname: json['fname'] as String,
      lname: json['lname'] as String,
    );

Map<String, dynamic> _$PopulatedUserInfoModelToJson(
        PopulatedUserInfoModel instance) =>
    <String, dynamic>{
      'fname': instance.fname,
      'lname': instance.lname,
    };

Map<String, dynamic> _$SaleApiModelToJson(SaleApiModel instance) =>
    <String, dynamic>{
      'stringify': instance.stringify,
      'hashCode': instance.hashCode,
      '_id': instance.saleId,
      'invoiceNumber': instance.invoiceNumber,
      'shop': instance.shopId,
      'customerId': instance.customerId,
      'customerInfo': instance.customerInfo,
      'saleType': _$SaleTypeEnumMap[instance.saleType]!,
      'items': instance.items,
      'subTotal': instance.subTotal,
      'discount': instance.discount,
      'tax': instance.tax,
      'grandTotal': instance.grandTotal,
      'amountPaid': instance.amountPaid,
      'amountDue': instance.amountDue,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'saleDate': instance.saleDate.toIso8601String(),
      'status': _$SaleStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'props': instance.props,
    };

const _$SaleTypeEnumMap = {
  SaleType.CUSTOMER: 'CUSTOMER',
  SaleType.CASH: 'CASH',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.PAID: 'PAID',
  PaymentStatus.PARTIAL: 'PARTIAL',
  PaymentStatus.UNPAID: 'UNPAID',
};

const _$SaleStatusEnumMap = {
  SaleStatus.COMPLETED: 'COMPLETED',
  SaleStatus.CANCELLED: 'CANCELLED',
};
