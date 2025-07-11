import 'package:equatable/equatable.dart';

class CustomerEntity extends Equatable {
  final String? customerId;
  final String name;
  final String phone;
  final String email;
  final String address;
  final double currentBalance;
  final String shopId;

  const CustomerEntity({
    this.customerId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.currentBalance,
    required this.shopId,
  });

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
