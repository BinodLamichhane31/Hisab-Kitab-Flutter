import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/customers/domain/repository/customer_repository.dart';

class DeleteCustomerParams extends Equatable {
  final String customerId;

  const DeleteCustomerParams({required this.customerId});

  @override
  List<Object?> get props => [customerId];
}

class DeleteCustomerUsecase
    implements UseCaseWithParams<void, DeleteCustomerParams> {
  final ICustomerRepository customerRepository;

  DeleteCustomerUsecase({required this.customerRepository});

  @override
  Future<Either<Failure, void>> call(DeleteCustomerParams params) {
    return customerRepository.deleteCustomer(params.customerId);
  }
}
