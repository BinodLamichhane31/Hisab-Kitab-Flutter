import 'package:equatable/equatable.dart';

class CustomerEntity extends Equatable {
  final String? customerId;
  final String name;
  final String phone;
  final String email;
  final String address;
  final double currentBalance;
  final double totalSpent;
  final String shopId;

  const CustomerEntity({
    this.customerId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.currentBalance,
    required this.totalSpent,
    required this.shopId,
  });

  CustomerEntity copyWith({
    String? customerId,
    String? name,
    String? phone,
    String? email,
    String? address,
    double? currentBalance,
    double? totalSpent,
    String? shopId,
  }) {
    return CustomerEntity(
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      currentBalance: currentBalance ?? this.currentBalance,
      totalSpent: totalSpent ?? this.totalSpent,
      shopId: shopId ?? this.shopId,
    );
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
