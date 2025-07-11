import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_api_model.g.dart';

@JsonSerializable()
class CustomerApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? customerId;
  final String name;
  final String phone;
  final String email;
  final String address;
  final double currentBalance;
  @JsonKey(name: 'shop')
  final String shopId;

  const CustomerApiModel({
    required this.customerId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.currentBalance,
    required this.shopId,
  });

  factory CustomerApiModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerApiModelToJson(this);

  factory CustomerApiModel.fromEntity(CustomerEntity customer) {
    return CustomerApiModel(
      customerId: customer.customerId,
      name: customer.name,
      phone: customer.phone,
      email: customer.email,
      address: customer.address,
      currentBalance: customer.currentBalance,
      shopId: customer.shopId,
    );
  }

  CustomerEntity toEntity() {
    return CustomerEntity(
      customerId: customerId,
      name: name,
      phone: phone,
      email: email,
      address: address,
      currentBalance: currentBalance,
      shopId: shopId,
    );
  }

  static List<CustomerEntity> toEntityList(List<CustomerApiModel> entityList) {
    return entityList.map((data) => data.toEntity()).toList();
  }

  static List<CustomerApiModel> fromEntityList(
    List<CustomerEntity> entityList,
  ) {
    return entityList
        .map((entity) => CustomerApiModel.fromEntity(entity))
        .toList();
  }

  @override
  List<Object?> get props => [
    customerId,
    name,
    phone,
    email,
    address,
    currentBalance,
    shopId,
  ];
}
