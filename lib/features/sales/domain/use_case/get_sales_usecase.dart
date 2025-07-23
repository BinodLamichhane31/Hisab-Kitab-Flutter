import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_enums.dart';
import 'package:hisab_kitab/features/sales/domain/repository/sale_repository.dart';

class GetSalesParams extends Equatable {
  final String shopId;
  final int? page;
  final int? limit;
  final String? search;
  final String? customerId;
  final SaleType? saleType;

  const GetSalesParams({
    required this.shopId,
    this.page,
    this.limit,
    this.search,
    this.customerId,
    this.saleType,
  });

  @override
  List<Object?> get props => [
    shopId,
    page,
    limit,
    search,
    customerId,
    saleType,
  ];
}

class GetSalesUsecase
    implements UseCaseWithParams<List<SaleEntity>, GetSalesParams> {
  final ISaleRepository _saleRepository;

  GetSalesUsecase({required ISaleRepository saleRepository})
    : _saleRepository = saleRepository;

  @override
  Future<Either<Failure, List<SaleEntity>>> call(GetSalesParams params) {
    return _saleRepository.getSales(
      shopId: params.shopId,
      page: params.page,
      limit: params.limit,
      search: params.search,
      customerId: params.customerId,
      saleType: params.saleType,
    );
  }
}
