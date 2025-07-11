import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';

abstract interface class ICustomerRepository {
  Future<Either<Failure, void>> addCustomer(CustomerEntity customer);
  Future<Either<Failure, List<CustomerEntity>>> getCustomerByShop(
    String shopId, {
    String? search,
  });
  Future<Either<Failure, CustomerEntity>> getCustomerById(String customerId);
  Future<Either<Failure, CustomerEntity>> updateCustomer(
    CustomerEntity customer,
  );
  Future<Either<Failure, bool>> deleteCustomer(String customerId);
}
