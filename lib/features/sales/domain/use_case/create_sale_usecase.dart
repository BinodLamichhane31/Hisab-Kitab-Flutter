import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart';
import 'package:hisab_kitab/features/sales/domain/repository/sale_repository.dart';

class CreateSaleParams extends Equatable {
  final String shopId;
  final String? customerId;
  final List<({String productId, int quantity, double priceAtSale})> items;
  final double discount;
  final double tax;
  final double amountPaid;
  final String? notes;
  final DateTime? saleDate;

  const CreateSaleParams({
    required this.shopId,
    this.customerId,
    required this.items,
    this.discount = 0.0,
    this.tax = 0.0,
    required this.amountPaid,
    this.notes,
    this.saleDate,
  });

  @override
  List<Object?> get props => [
    shopId,
    customerId,
    items,
    discount,
    tax,
    amountPaid,
    notes,
    saleDate,
  ];
}

class CreateSaleUsecase
    implements UseCaseWithParams<SaleEntity, CreateSaleParams> {
  final ISaleRepository _saleRepository;

  CreateSaleUsecase({required ISaleRepository saleRepository})
    : _saleRepository = saleRepository;

  @override
  Future<Either<Failure, SaleEntity>> call(CreateSaleParams params) async {
    final saleRequest = CreateSaleRequest(
      shopId: params.shopId,
      customerId: params.customerId,
      items: params.items,
      discount: params.discount,
      tax: params.tax,
      amountPaid: params.amountPaid,
      notes: params.notes,
      saleDate: params.saleDate,
    );
    return await _saleRepository.createSale(saleRequest);
  }
}
