import 'package:equatable/equatable.dart';

class SupplierEntity extends Equatable {
  final String? supplierId;
  final String name;
  final String phone;
  final String email;
  final String address;
  final double currentBalance;
  final String shopId;

  const SupplierEntity({
    this.supplierId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.currentBalance,
    required this.shopId,
  });

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
