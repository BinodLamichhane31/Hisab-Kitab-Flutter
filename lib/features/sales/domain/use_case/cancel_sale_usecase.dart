import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart';
import 'package:hisab_kitab/features/sales/domain/repository/sale_repository.dart';

class CancelSaleParams extends Equatable {
  final String saleId;

  const CancelSaleParams({required this.saleId});

  @override
  List<Object?> get props => [saleId];
}

class CancelSaleUsecase
    implements UseCaseWithParams<SaleEntity, CancelSaleParams> {
  final ISaleRepository _saleRepository;

  CancelSaleUsecase({required ISaleRepository saleRepository})
    : _saleRepository = saleRepository;

  @override
  Future<Either<Failure, SaleEntity>> call(CancelSaleParams params) {
    return _saleRepository.cancelSale(params.saleId);
  }
}
