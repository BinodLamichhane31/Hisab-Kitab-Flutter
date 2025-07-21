import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';

abstract class CustomerDetailEvent extends Equatable {
  const CustomerDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerDetailEvent extends CustomerDetailEvent {
  final String customerId;

  const LoadCustomerDetailEvent(this.customerId);

  @override
  List<Object?> get props => [customerId];
}

class UpdateCustomerDetailEvent extends CustomerDetailEvent {
  final CustomerEntity customer;

  const UpdateCustomerDetailEvent(this.customer);

  @override
  List<Object?> get props => [customer];
}

class DeleteCustomerEvent extends CustomerDetailEvent {
  final String customerId;

  const DeleteCustomerEvent(this.customerId);

  @override
  List<Object?> get props => [customerId];
}
