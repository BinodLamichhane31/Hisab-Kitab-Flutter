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
  Future<Either<Failure, CustomerEntity>> getCustomerById(
    String customerId,
  ) async {
    try {
      final customer = await _customerRemoteDataSource.getCustomerById(
        customerId,
      );
      return Right(customer);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
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
  ) async {
    try {
      final updatedCustomer = await _customerRemoteDataSource.updateCustomer(
        customer,
      );
      return Right(updatedCustomer);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCustomer(String customerId) async {
    try {
      final deleted = await _customerRemoteDataSource.deleteCustomer(
        customerId,
      );
      return Right(deleted);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
