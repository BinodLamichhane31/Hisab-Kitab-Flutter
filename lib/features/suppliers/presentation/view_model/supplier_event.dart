import 'package:equatable/equatable.dart';

abstract class SupplierEvent extends Equatable {
  const SupplierEvent();

  @override
  List<Object?> get props => [];
}

class LoadSuppliersEvent extends SupplierEvent {
  final String shopId;
  final String? search;

  const LoadSuppliersEvent({required this.shopId, this.search});

  @override
  List<Object?> get props => [shopId, search];
}

class CreateSupplierEvent extends SupplierEvent {
  final String name;
  final String phone;
  final String email;
  final String address;
  final double currentBalance;
  final String shopId;

  const CreateSupplierEvent({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.currentBalance,
    required this.shopId,
  });

  @override
  List<Object?> get props => [
    name,
    phone,
    email,
    address,
    currentBalance,
    shopId,
  ];
}
