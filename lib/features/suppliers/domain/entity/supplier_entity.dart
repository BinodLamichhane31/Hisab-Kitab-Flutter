import 'package:equatable/equatable.dart';

class SupplierEntity extends Equatable {
  final String? supplierId;
  final String name;
  final String phone;
  final String email;
  final String address;
  final double currentBalance;
  final double totalSupplied;
  final String shopId;

  const SupplierEntity({
    this.supplierId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.currentBalance,
    required this.totalSupplied,
    required this.shopId,
  });
  SupplierEntity copyWith({
    String? supplierId,
    String? name,
    String? phone,
    String? email,
    String? address,
    double? currentBalance,
    double? totalSupplied,
    String? shopId,
  }) {
    return SupplierEntity(
      supplierId: supplierId ?? this.supplierId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      currentBalance: currentBalance ?? this.currentBalance,
      totalSupplied: totalSupplied ?? this.totalSupplied,
      shopId: shopId ?? this.shopId,
    );
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
