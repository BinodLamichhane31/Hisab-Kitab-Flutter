import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/customers/domain/repository/customer_repository.dart';

class AddCustomerParams extends Equatable {
  final String name;
  final String phone;
  final String email;
  final String address;
  final double currentBalance;
  final String shopId;

  const AddCustomerParams({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.currentBalance,
    required this.shopId,
  });

  const AddCustomerParams.initial()
    : name = '_empty.string',
      phone = '_empty.string',
      email = '_empty.string',
      address = '_empty.string',
      currentBalance = 0.0,
      shopId = '_empty.string';

  @override
  List<Object?> get props => [
    name,
    phone,
    email,
    address,
    currentBalance,
    shopId,
  ];
}

class AddCustomerUsecase implements UseCaseWithParams<void, AddCustomerParams> {
  final ICustomerRepository customerRepository;

  AddCustomerUsecase({required this.customerRepository});
  @override
  Future<Either<Failure, void>> call(AddCustomerParams params) async {
    return await customerRepository.addCustomer(
      CustomerEntity(
        name: params.name,
        phone: params.phone,
        email: params.email,
        address: params.address,
        currentBalance: params.currentBalance,
        shopId: params.shopId,
      ),
    );
  }
}
