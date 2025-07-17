import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';

class SupplierState extends Equatable {
  final List<SupplierEntity> suppliers;
  final bool isLoading;
  final String? errorMessage;

  const SupplierState({
    required this.suppliers,
    required this.isLoading,
    this.errorMessage,
  });

  const SupplierState.initial()
    : suppliers = const [],
      isLoading = false,
      errorMessage = null;

  SupplierState copyWith({
    List<SupplierEntity>? suppliers,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SupplierState(
      suppliers: suppliers ?? this.suppliers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [suppliers, isLoading, errorMessage];
}
