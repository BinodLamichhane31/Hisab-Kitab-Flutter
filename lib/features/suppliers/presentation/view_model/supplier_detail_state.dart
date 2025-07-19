import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';

enum SupplierDetailStatus { initial, loading, success, failure, deleted }

class SupplierDetailState extends Equatable {
  final SupplierDetailStatus status;
  final SupplierEntity? supplier;
  final String? errorMessage;

  const SupplierDetailState({
    required this.status,
    this.supplier,
    this.errorMessage,
  });

  const SupplierDetailState.initial()
    : status = SupplierDetailStatus.initial,
      supplier = null,
      errorMessage = null;

  SupplierDetailState copyWith({
    SupplierDetailStatus? status,
    SupplierEntity? supplier,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SupplierDetailState(
      status: status ?? this.status,
      supplier: supplier ?? this.supplier,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, supplier, errorMessage];
}
