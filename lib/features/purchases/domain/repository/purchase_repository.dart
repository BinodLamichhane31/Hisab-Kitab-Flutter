import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_entity.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_enums.dart';

class CreatePurchaseRequest {
  final String shopId;
  final String? supplierId;
  final List<({String productId, int quantity, double unitCost})> items;
  final double discount;
  final double amountPaid;
  final String? billNumber;
  final String? notes;
  final DateTime? purchaseDate;

  CreatePurchaseRequest({
    required this.shopId,
    this.supplierId,
    required this.items,
    required this.discount,
    required this.amountPaid,
    this.billNumber,
    this.notes,
    this.purchaseDate,
  });
}

abstract interface class IPurchaseRepository {
  Future<Either<Failure, PurchaseEntity>> createPurchase(
    CreatePurchaseRequest purchaseRequest,
  );

  Future<Either<Failure, List<PurchaseEntity>>> getPurchases({
    required String shopId,
    int? page,
    int? limit,
    String? search,
    String? supplierId,
    PurchaseType? purchaseType,
  });

  Future<Either<Failure, PurchaseEntity>> getPurchaseById(String purchaseId);

  Future<Either<Failure, PurchaseEntity>> cancelPurchase(String purchaseId);

  Future<Either<Failure, PurchaseEntity>> recordPaymentForPurchase({
    required String purchaseId,
    required double amountPaid,
    String? paymentMethod,
  });
}
