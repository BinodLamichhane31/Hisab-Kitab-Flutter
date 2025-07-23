import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_entity.dart';
import 'package:hisab_kitab/features/purchases/domain/repository/purchase_repository.dart';

class CreatePurchaseParams extends Equatable {
  final String shopId;
  final String? supplierId;
  final List<({String productId, int quantity, double unitCost})> items;
  final double discount;
  final double amountPaid;
  final String? billNumber;
  final String? notes;
  final DateTime? purchaseDate;

  const CreatePurchaseParams({
    required this.shopId,
    this.supplierId,
    required this.items,
    this.discount = 0.0,
    required this.amountPaid,
    this.billNumber,
    this.notes,
    this.purchaseDate,
  });

  @override
  List<Object?> get props => [
    shopId,
    supplierId,
    items,
    discount,
    amountPaid,
    billNumber,
    notes,
    purchaseDate,
  ];
}

class CreatePurchaseUsecase
    implements UseCaseWithParams<PurchaseEntity, CreatePurchaseParams> {
  final IPurchaseRepository _purchaseRepository;

  CreatePurchaseUsecase({required IPurchaseRepository purchaseRepository})
    : _purchaseRepository = purchaseRepository;

  @override
  Future<Either<Failure, PurchaseEntity>> call(
    CreatePurchaseParams params,
  ) async {
    final purchaseRequest = CreatePurchaseRequest(
      shopId: params.shopId,
      supplierId: params.supplierId,
      items: params.items,
      discount: params.discount,
      amountPaid: params.amountPaid,
      billNumber: params.billNumber,
      notes: params.notes,
      purchaseDate: params.purchaseDate,
    );
    return await _purchaseRepository.createPurchase(purchaseRequest);
  }
}
