import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart';
import 'package:hisab_kitab/features/sales/domain/repository/sale_repository.dart';

class GetSaleByIdParams extends Equatable {
  final String saleId;

  const GetSaleByIdParams({required this.saleId});

  @override
  List<Object?> get props => [saleId];
}

class GetSaleByIdUsecase
    implements UseCaseWithParams<SaleEntity, GetSaleByIdParams> {
  final ISaleRepository _saleRepository;

  GetSaleByIdUsecase({required ISaleRepository saleRepository})
    : _saleRepository = saleRepository;

  @override
  Future<Either<Failure, SaleEntity>> call(GetSaleByIdParams params) {
    return _saleRepository.getSaleById(params.saleId);
  }
}
