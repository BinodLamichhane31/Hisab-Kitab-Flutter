import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomersEvent extends CustomerEvent {
  final String shopId;
  final String? search;

  const LoadCustomersEvent({required this.shopId, this.search});

  @override
  List<Object?> get props => [shopId, search];
}

class CreateCustomerEvent extends CustomerEvent {
  final String name;
  final String phone;
  final String email;
  final String address;
  final double currentBalance;
  final String shopId;

  const CreateCustomerEvent({
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
