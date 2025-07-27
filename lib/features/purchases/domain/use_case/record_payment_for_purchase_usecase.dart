import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_entity.dart';
import 'package:hisab_kitab/features/purchases/domain/repository/purchase_repository.dart';

class RecordPaymentForPurchaseParams extends Equatable {
  final String purchaseId;
  final double amountPaid;
  final String? paymentMethod;

  const RecordPaymentForPurchaseParams({
    required this.purchaseId,
    required this.amountPaid,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [purchaseId, amountPaid, paymentMethod];
}

class RecordPaymentForPurchaseUsecase
    implements
        UseCaseWithParams<PurchaseEntity, RecordPaymentForPurchaseParams> {
  final IPurchaseRepository _purchaseRepository;

  RecordPaymentForPurchaseUsecase({
    required IPurchaseRepository purchaseRepository,
  }) : _purchaseRepository = purchaseRepository;

  @override
  Future<Either<Failure, PurchaseEntity>> call(
    RecordPaymentForPurchaseParams params,
  ) {
    return _purchaseRepository.recordPaymentForPurchase(
      purchaseId: params.purchaseId,
      amountPaid: params.amountPaid,
      paymentMethod: params.paymentMethod,
    );
  }
}
