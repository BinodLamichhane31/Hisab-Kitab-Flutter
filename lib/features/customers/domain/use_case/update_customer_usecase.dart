import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/customers/domain/repository/customer_repository.dart';

/// Params class for passing the updated customer entity to the use case.
class UpdateCustomerParams extends Equatable {
  final CustomerEntity customer;

  const UpdateCustomerParams({required this.customer});

  @override
  List<Object?> get props => [customer];
}

class UpdateCustomerUsecase
    implements UseCaseWithParams<CustomerEntity, UpdateCustomerParams> {
  final ICustomerRepository customerRepository;

  UpdateCustomerUsecase({required this.customerRepository});

  @override
  Future<Either<Failure, CustomerEntity>> call(UpdateCustomerParams params) {
    return customerRepository.updateCustomer(params.customer);
  }
}
