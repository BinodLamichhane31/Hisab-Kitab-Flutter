import 'package:equatable/equatable.dart';

abstract class SaleDetailEvent extends Equatable {
  const SaleDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadSaleDetailEvent extends SaleDetailEvent {
  final String saleId;

  const LoadSaleDetailEvent({required this.saleId});

  @override
  List<Object?> get props => [saleId];
}

class CancelSaleEvent extends SaleDetailEvent {
  final String saleId;

  const CancelSaleEvent({required this.saleId});

  @override
  List<Object?> get props => [saleId];
}

class RecordPaymentEvent extends SaleDetailEvent {
  final String saleId;
  final double amountPaid;
  final String? paymentMethod;

  const RecordPaymentEvent({
    required this.saleId,
    required this.amountPaid,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [saleId, amountPaid, paymentMethod];
}
