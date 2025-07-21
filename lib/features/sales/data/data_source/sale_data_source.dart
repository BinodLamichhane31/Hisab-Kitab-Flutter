import 'package:hisab_kitab/features/sales/data/model/sale_api_model.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_enums.dart';

// A simple response model for paginated data from the API
class PaginatedSalesResponse {
  final List<SaleApiModel> data;
  final Map<String, dynamic> pagination;

  PaginatedSalesResponse({required this.data, required this.pagination});

  factory PaginatedSalesResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedSalesResponse(
      data:
          (json['data'] as List)
              .map((item) => SaleApiModel.fromJson(item))
              .toList(),
      pagination: json['pagination'],
    );
  }
}

abstract interface class ISaleDataSource {
  Future<SaleApiModel> createSale(Map<String, dynamic> saleData);

  Future<PaginatedSalesResponse> getSales({
    required String shopId,
    int? page,
    int? limit,
    String? search,
    String? customerId,
    SaleType? saleType,
  });

  Future<SaleApiModel> getSaleById(String saleId);

  Future<SaleApiModel> cancelSale(String saleId);

  Future<SaleApiModel> recordPayment({
    required String saleId,
    required double amountPaid,
    String? paymentMethod,
  });
}
