import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';

class CustomerState extends Equatable {
  final List<CustomerEntity> customers;
  final bool isLoading;
  final String? errorMessage;

  const CustomerState({
    required this.customers,
    required this.isLoading,
    this.errorMessage,
  });

  const CustomerState.initial()
    : customers = const [],
      isLoading = false,
      errorMessage = null;

  CustomerState copyWith({
    List<CustomerEntity>? customers,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CustomerState(
      customers: customers ?? this.customers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [customers, isLoading, errorMessage];
}
