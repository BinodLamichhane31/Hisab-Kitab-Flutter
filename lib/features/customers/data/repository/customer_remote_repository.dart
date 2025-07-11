import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/customers/data/data_source/remote_data_source/customer_remote_data_source.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/customers/domain/repository/customer_repository.dart';

class CustomerRemoteRepository implements ICustomerRepository {
  final CustomerRemoteDataSource _customerRemoteDataSource;

  CustomerRemoteRepository({
    required CustomerRemoteDataSource customerRemoteDataSource,
  }) : _customerRemoteDataSource = customerRemoteDataSource;

  @override
  Future<Either<Failure, void>> addCustomer(CustomerEntity customer) async {
    try {
      await _customerRemoteDataSource.addCustomer(customer);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerEntity>> getCustomerById(String customerId) {
    // TODO: implement getCustomerById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<CustomerEntity>>> getCustomerByShop(
    String shopId, {
    String? search,
  }) async {
    try {
      final customers = await _customerRemoteDataSource.getCustomerByShop(
        shopId,
        search: search,
      );
      return Right(customers);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerEntity>> updateCustomer(
    CustomerEntity customer,
  ) {
    // TODO: implement updateCustomer
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteCustomer(String customerId) {
    // TODO: implement deleteCustomer
    throw UnimplementedError();
  }
}
