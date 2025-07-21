import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_enums.dart';

class CreateSaleRequest {
  final String shopId;
  final String? customerId;
  final List<({String productId, int quantity, double priceAtSale})> items;
  final double discount;
  final double tax;
  final double amountPaid;
  final String? notes;
  final DateTime? saleDate;

  CreateSaleRequest({
    required this.shopId,
    this.customerId,
    required this.items,
    required this.discount,
    required this.tax,
    required this.amountPaid,
    this.notes,
    this.saleDate,
  });
}

class PaginatedSalesEntity {
  final List<SaleEntity> sales;
  final int currentPage;
  final int totalPages;
  final int totalSales;

  PaginatedSalesEntity({
    required this.sales,
    required this.currentPage,
    required this.totalPages,
    required this.totalSales,
  });
}

abstract interface class ISaleRepository {
  Future<Either<Failure, SaleEntity>> createSale(CreateSaleRequest saleRequest);

  Future<Either<Failure, PaginatedSalesEntity>> getSales({
    required String shopId,
    int? page,
    int? limit,
    String? search,
    String? customerId,
    SaleType? saleType,
  });

  Future<Either<Failure, SaleEntity>> getSaleById(String saleId);

  Future<Either<Failure, SaleEntity>> cancelSale(String saleId);

  Future<Either<Failure, SaleEntity>> recordPayment({
    required String saleId,
    required double amountPaid,
    String? paymentMethod,
  });
}
