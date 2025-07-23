import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart';

enum SaleDetailStatus {
  initial,
  loading,
  success,
  error,
  cancelled,
  paymentRecorded,
}

class SaleDetailState extends Equatable {
  final SaleDetailStatus status;
  final SaleEntity? sale;
  final String? successMessage;
  final String? errorMessage;

  const SaleDetailState({
    required this.status,
    this.sale,
    this.successMessage,
    this.errorMessage,
  });

  const SaleDetailState.initial()
    : status = SaleDetailStatus.initial,
      sale = null,
      successMessage = null,
      errorMessage = null;

  SaleDetailState copyWith({
    SaleDetailStatus? status,
    SaleEntity? sale,
    String? successMessage,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SaleDetailState(
      status: status ?? this.status,
      sale: sale ?? this.sale,
      successMessage: successMessage,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, sale, successMessage, errorMessage];
}
