import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/purchases/data/data_source/purchase_data_source.dart';
import 'package:hisab_kitab/features/purchases/data/model/purchase_api_model.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_entity.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_enums.dart';
import 'package:hisab_kitab/features/purchases/domain/repository/purchase_repository.dart';

class PurchaseRemoteRepository implements IPurchaseRepository {
  final IPurchaseDataSource _dataSource;

  PurchaseRemoteRepository({required IPurchaseDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<Failure, PurchaseEntity>> createPurchase(
    CreatePurchaseRequest request,
  ) async {
    try {
      final purchaseData = {
        'shopId': request.shopId,
        if (request.supplierId != null) 'supplierId': request.supplierId,
        'items':
            request.items
                .map(
                  (item) => {
                    'productId': item.productId,
                    'quantity': item.quantity,
                    'unitCost': item.unitCost,
                  },
                )
                .toList(),
        'discount': request.discount,
        'amountPaid': request.amountPaid,
        if (request.billNumber != null) 'billNumber': request.billNumber,
        if (request.notes != null) 'notes': request.notes,
        if (request.purchaseDate != null)
          'purchaseDate': request.purchaseDate!.toIso8601String(),
      };
      final newPurchaseModel = await _dataSource.createPurchase(purchaseData);
      return Right(newPurchaseModel.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PurchaseEntity>>> getPurchases({
    required String shopId,
    int? page,
    int? limit,
    String? search,
    String? supplierId,
    PurchaseType? purchaseType,
  }) async {
    try {
      final response = await _dataSource.getPurchases(
        shopId: shopId,
        page: page,
        limit: limit,
        search: search,
        supplierId: supplierId,
        purchaseType: purchaseType,
      );
      return Right(PurchaseApiModel.toEntityList(response.data));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseEntity>> getPurchaseById(
    String purchaseId,
  ) async {
    try {
      final model = await _dataSource.getPurchaseById(purchaseId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseEntity>> cancelPurchase(
    String purchaseId,
  ) async {
    try {
      final model = await _dataSource.cancelPurchase(purchaseId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseEntity>> recordPaymentForPurchase({
    required String purchaseId,
    required double amountPaid,
    String? paymentMethod,
  }) async {
    try {
      final model = await _dataSource.recordPaymentForPurchase(
        purchaseId: purchaseId,
        amountPaid: amountPaid,
        paymentMethod: paymentMethod,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
