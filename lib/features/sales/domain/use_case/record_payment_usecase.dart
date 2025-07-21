import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart';
import 'package:hisab_kitab/features/sales/domain/repository/sale_repository.dart';

class RecordPaymentParams extends Equatable {
  final String saleId;
  final double amountPaid;
  final String? paymentMethod;

  const RecordPaymentParams({
    required this.saleId,
    required this.amountPaid,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [saleId, amountPaid, paymentMethod];
}

class RecordPaymentUsecase
    implements UseCaseWithParams<SaleEntity, RecordPaymentParams> {
  final ISaleRepository _saleRepository;

  RecordPaymentUsecase({required ISaleRepository saleRepository})
    : _saleRepository = saleRepository;

  @override
  Future<Either<Failure, SaleEntity>> call(RecordPaymentParams params) {
    return _saleRepository.recordPayment(
      saleId: params.saleId,
      amountPaid: params.amountPaid,
      paymentMethod: params.paymentMethod,
    );
  }
}
