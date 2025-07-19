import 'package:equatable/equatable.dart';

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

class DeleteCustomerEvent extends CustomerDetailEvent {
  final String customerId;

  const DeleteCustomerEvent(this.customerId);

  @override
  List<Object?> get props => [customerId];
}
