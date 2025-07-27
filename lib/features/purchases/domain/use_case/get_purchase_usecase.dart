import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_entity.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_enums.dart';
import 'package:hisab_kitab/features/purchases/domain/repository/purchase_repository.dart';

class GetPurchasesParams extends Equatable {
  final String shopId;
  final int? page;
  final int? limit;
  final String? search;
  final String? supplierId;
  final PurchaseType? purchaseType;

  const GetPurchasesParams({
    required this.shopId,
    this.page,
    this.limit,
    this.search,
    this.supplierId,
    this.purchaseType,
  });

  @override
  List<Object?> get props => [
    shopId,
    page,
    limit,
    search,
    supplierId,
    purchaseType,
  ];
}

class GetPurchasesUsecase
    implements UseCaseWithParams<List<PurchaseEntity>, GetPurchasesParams> {
  final IPurchaseRepository _purchaseRepository;

  GetPurchasesUsecase({required IPurchaseRepository purchaseRepository})
    : _purchaseRepository = purchaseRepository;

  @override
  Future<Either<Failure, List<PurchaseEntity>>> call(
    GetPurchasesParams params,
  ) {
    return _purchaseRepository.getPurchases(
      shopId: params.shopId,
      page: params.page,
      limit: params.limit,
      search: params.search,
      supplierId: params.supplierId,
      purchaseType: params.purchaseType,
    );
  }
}
