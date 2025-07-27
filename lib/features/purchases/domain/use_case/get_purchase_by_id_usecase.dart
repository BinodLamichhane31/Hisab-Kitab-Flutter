import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_entity.dart';
import 'package:hisab_kitab/features/purchases/domain/repository/purchase_repository.dart';

class GetPurchaseByIdParams extends Equatable {
  final String purchaseId;

  const GetPurchaseByIdParams({required this.purchaseId});

  @override
  List<Object?> get props => [purchaseId];
}

class GetPurchaseByIdUsecase
    implements UseCaseWithParams<PurchaseEntity, GetPurchaseByIdParams> {
  final IPurchaseRepository _purchaseRepository;

  GetPurchaseByIdUsecase({required IPurchaseRepository purchaseRepository})
    : _purchaseRepository = purchaseRepository;

  @override
  Future<Either<Failure, PurchaseEntity>> call(GetPurchaseByIdParams params) {
    return _purchaseRepository.getPurchaseById(params.purchaseId);
  }
}
