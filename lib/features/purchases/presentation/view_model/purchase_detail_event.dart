import 'package:equatable/equatable.dart';

abstract class PurchaseDetailEvent extends Equatable {
  const PurchaseDetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadPurchaseDetailEvent extends PurchaseDetailEvent {
  final String purchaseId;
  const LoadPurchaseDetailEvent({required this.purchaseId});
  @override
  List<Object?> get props => [purchaseId];
}

class CancelPurchaseEvent extends PurchaseDetailEvent {
  final String purchaseId;
  const CancelPurchaseEvent({required this.purchaseId});
  @override
  List<Object?> get props => [purchaseId];
}

class RecordPaymentEvent extends PurchaseDetailEvent {
  final String purchaseId;
  final double amountPaid;
  final String? paymentMethod;

  const RecordPaymentEvent({
    required this.purchaseId,
    required this.amountPaid,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [purchaseId, amountPaid, paymentMethod];
}
