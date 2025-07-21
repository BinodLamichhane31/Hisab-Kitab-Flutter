import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/sales/data/data_source/sale_data_source.dart';
import 'package:hisab_kitab/features/sales/data/model/sale_api_model.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_enums.dart';
import 'package:hisab_kitab/features/sales/domain/repository/sale_repository.dart';

class SaleRemoteRepository implements ISaleRepository {
  final ISaleDataSource _saleDataSource;

  SaleRemoteRepository({required ISaleDataSource saleDataSource})
    : _saleDataSource = saleDataSource;

  @override
  Future<Either<Failure, SaleEntity>> createSale(
    CreateSaleRequest saleRequest,
  ) async {
    try {
      final saleData = {
        'shopId': saleRequest.shopId,
        if (saleRequest.customerId != null)
          'customerId': saleRequest.customerId,
        'items':
            saleRequest.items
                .map(
                  (item) => {
                    'productId': item.productId,
                    'quantity': item.quantity,
                    'priceAtSale': item.priceAtSale,
                  },
                )
                .toList(),
        'discount': saleRequest.discount,
        'tax': saleRequest.tax,
        'amountPaid': saleRequest.amountPaid,
        if (saleRequest.notes != null) 'notes': saleRequest.notes,
        if (saleRequest.saleDate != null)
          'saleDate': saleRequest.saleDate!.toIso8601String(),
      };

      final newSaleModel = await _saleDataSource.createSale(saleData);
      return Right(newSaleModel.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedSalesEntity>> getSales({
    required String shopId,
    int? page,
    int? limit,
    String? search,
    String? customerId,
    SaleType? saleType,
  }) async {
    try {
      final response = await _saleDataSource.getSales(
        shopId: shopId,
        page: page,
        limit: limit,
        search: search,
        customerId: customerId,
        saleType: saleType,
      );

      final paginatedEntity = PaginatedSalesEntity(
        sales: SaleApiModel.toEntityList(response.data),
        currentPage: response.pagination['currentPage'],
        totalPages: response.pagination['totalPages'],
        totalSales: response.pagination['totalSales'],
      );

      return Right(paginatedEntity);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SaleEntity>> getSaleById(String saleId) async {
    try {
      final saleModel = await _saleDataSource.getSaleById(saleId);
      return Right(saleModel.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SaleEntity>> cancelSale(String saleId) async {
    try {
      final cancelledSaleModel = await _saleDataSource.cancelSale(saleId);
      return Right(cancelledSaleModel.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SaleEntity>> recordPayment({
    required String saleId,
    required double amountPaid,
    String? paymentMethod,
  }) async {
    try {
      final updatedSaleModel = await _saleDataSource.recordPayment(
        saleId: saleId,
        amountPaid: amountPaid,
        paymentMethod: paymentMethod,
      );
      return Right(updatedSaleModel.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
