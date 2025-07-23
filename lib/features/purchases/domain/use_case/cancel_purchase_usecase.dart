import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_entity.dart';
import 'package:hisab_kitab/features/purchases/domain/repository/purchase_repository.dart';

class CancelPurchaseParams extends Equatable {
  final String purchaseId;

  const CancelPurchaseParams({required this.purchaseId});

  @override
  List<Object?> get props => [purchaseId];
}

class CancelPurchaseUsecase
    implements UseCaseWithParams<PurchaseEntity, CancelPurchaseParams> {
  final IPurchaseRepository _purchaseRepository;

  CancelPurchaseUsecase({required IPurchaseRepository purchaseRepository})
    : _purchaseRepository = purchaseRepository;

  @override
  Future<Either<Failure, PurchaseEntity>> call(CancelPurchaseParams params) {
    return _purchaseRepository.cancelPurchase(params.purchaseId);
  }
}
