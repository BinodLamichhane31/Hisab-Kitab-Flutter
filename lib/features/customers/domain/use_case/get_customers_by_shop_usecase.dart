import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/customers/domain/repository/customer_repository.dart';

class GetCustomersByShopParams extends Equatable {
  final String shopId;
  final String? search;

  const GetCustomersByShopParams({required this.shopId, this.search});

  @override
  List<Object?> get props => [shopId, search];
}

class GetCustomersByShopUsecase
    implements
        UseCaseWithParams<List<CustomerEntity>, GetCustomersByShopParams> {
  final ICustomerRepository customerRepository;

  GetCustomersByShopUsecase({required this.customerRepository});

  @override
  Future<Either<Failure, List<CustomerEntity>>> call(
    GetCustomersByShopParams params,
  ) {
    final customers = customerRepository.getCustomerByShop(params.shopId);
    return customers;
  }
}
