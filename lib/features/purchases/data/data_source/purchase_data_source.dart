import 'package:hisab_kitab/features/purchases/data/model/purchase_api_model.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_enums.dart';

class PaginatedPurchasesResponse {
  final List<PurchaseApiModel> data;
  final Map<String, dynamic> pagination;

  PaginatedPurchasesResponse({required this.data, required this.pagination});

  factory PaginatedPurchasesResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedPurchasesResponse(
      data:
          (json['data'] as List)
              .map((item) => PurchaseApiModel.fromJson(item))
              .toList(),
      pagination: json['pagination'],
    );
  }
}

abstract interface class IPurchaseDataSource {
  Future<PurchaseApiModel> createPurchase(Map<String, dynamic> purchaseData);

  Future<PaginatedPurchasesResponse> getPurchases({
    required String shopId,
    int? page,
    int? limit,
    String? search,
    String? supplierId,
    PurchaseType? purchaseType,
  });

  Future<PurchaseApiModel> getPurchaseById(String purchaseId);

  Future<PurchaseApiModel> cancelPurchase(String purchaseId);

  Future<PurchaseApiModel> recordPaymentForPurchase({
    required String purchaseId,
    required double amountPaid,
    String? paymentMethod,
  });
}
