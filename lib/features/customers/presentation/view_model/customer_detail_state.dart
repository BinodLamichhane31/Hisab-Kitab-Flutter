import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';

enum CustomerDetailStatus { initial, loading, success, failure, deleted }

class CustomerDetailState extends Equatable {
  final CustomerDetailStatus status;
  final CustomerEntity? customer;
  final String? errorMessage;

  const CustomerDetailState({
    required this.status,
    this.customer,
    this.errorMessage,
  });

  const CustomerDetailState.initial()
    : status = CustomerDetailStatus.initial,
      customer = null,
      errorMessage = null;

  CustomerDetailState copyWith({
    CustomerDetailStatus? status,
    CustomerEntity? customer,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CustomerDetailState(
      status: status ?? this.status,
      customer: customer ?? this.customer,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, customer, errorMessage];
}
