import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/customers/domain/repository/customer_repository.dart';

class GetCustomerParams extends Equatable {
  final String customerId;

  const GetCustomerParams({required this.customerId});

  @override
  List<Object?> get props => [customerId];
}

class GetCustomerUsecase
    implements UseCaseWithParams<CustomerEntity, GetCustomerParams> {
  final ICustomerRepository customerRepository;

  GetCustomerUsecase({required this.customerRepository});

  @override
  Future<Either<Failure, CustomerEntity>> call(GetCustomerParams params) {
    return customerRepository.getCustomerById(params.customerId);
  }
}
