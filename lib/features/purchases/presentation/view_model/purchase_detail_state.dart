import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_entity.dart';

enum PurchaseDetailStatus {
  initial,
  loading,
  success,
  error,
  cancelled,
  paymentRecorded,
}

class PurchaseDetailState extends Equatable {
  final PurchaseDetailStatus status;
  final PurchaseEntity? purchase;
  final String? successMessage;
  final String? errorMessage;

  const PurchaseDetailState({
    required this.status,
    this.purchase,
    this.successMessage,
    this.errorMessage,
  });

  const PurchaseDetailState.initial()
    : status = PurchaseDetailStatus.initial,
      purchase = null,
      successMessage = null,
      errorMessage = null;

  PurchaseDetailState copyWith({
    PurchaseDetailStatus? status,
    PurchaseEntity? purchase,
    String? successMessage,
    String? errorMessage,
    bool clearMessages = false,
  }) {
    return PurchaseDetailState(
      status: status ?? this.status,
      purchase: purchase ?? this.purchase,
      successMessage: clearMessages ? null : successMessage,
      errorMessage: clearMessages ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, purchase, successMessage, errorMessage];
}
