import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';

class SupplierState extends Equatable {
  final List<SupplierEntity> suppliers;
  final bool isLoading;
  final String? errorMessage;
  final String? search;

  const SupplierState({
    required this.suppliers,
    required this.isLoading,
    this.errorMessage,
    this.search,
  });

  const SupplierState.initial()
    : suppliers = const [],
      isLoading = false,
      errorMessage = null,
      search = null;

  SupplierState copyWith({
    List<SupplierEntity>? suppliers,
    bool? isLoading,
    String? errorMessage,
    String? search,
  }) {
    return SupplierState(
      suppliers: suppliers ?? this.suppliers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [suppliers, isLoading, errorMessage, search];
}
