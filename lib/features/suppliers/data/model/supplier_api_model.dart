import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'supplier_api_model.g.dart';

@JsonSerializable()
class SupplierApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? supplierId;
  final String name;
  final String phone;
  final String email;
  final String address;
  final double currentBalance;
  @JsonKey(name: 'shop')
  final String shopId;

  const SupplierApiModel({
    required this.supplierId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.currentBalance,
    required this.shopId,
  });

  factory SupplierApiModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierApiModelToJson(this);

  factory SupplierApiModel.fromEntity(SupplierEntity supplier) {
    return SupplierApiModel(
      supplierId: supplier.supplierId,
      name: supplier.name,
      phone: supplier.phone,
      email: supplier.email,
      address: supplier.address,
      currentBalance: supplier.currentBalance,
      shopId: supplier.shopId,
    );
  }

  SupplierEntity toEntity() {
    return SupplierEntity(
      supplierId: supplierId,
      name: name,
      phone: phone,
      email: email,
      address: address,
      currentBalance: currentBalance,
      shopId: shopId,
    );
  }

  static List<SupplierEntity> toEntityList(List<SupplierApiModel> entityList) {
    return entityList.map((data) => data.toEntity()).toList();
  }

  static List<SupplierApiModel> fromEntityList(
    List<SupplierEntity> entityList,
  ) {
    return entityList
        .map((entity) => SupplierApiModel.fromEntity(entity))
        .toList();
  }

  @override
  List<Object?> get props => [
    supplierId,
    name,
    phone,
    email,
    address,
    currentBalance,
    shopId,
  ];
}
