import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';

class CustomerState extends Equatable {
  final List<CustomerEntity> customers;
  final bool isLoading;
  final String? errorMessage;
  final String? search;

  const CustomerState({
    required this.customers,
    required this.isLoading,
    this.errorMessage,
    this.search,
  });

  const CustomerState.initial()
    : customers = const [],
      isLoading = false,
      errorMessage = null,
      search = null;

  CustomerState copyWith({
    List<CustomerEntity>? customers,
    bool? isLoading,
    String? errorMessage,
    String? search,
  }) {
    return CustomerState(
      customers: customers ?? this.customers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [customers, isLoading, errorMessage, search];
}
