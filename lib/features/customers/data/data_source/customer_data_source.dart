import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';

abstract interface class ICustomerDataSource {
  Future<void> addCustomer(CustomerEntity customer);
  Future<List<CustomerEntity>> getCustomerByShop(
    String shopId, {
    String? search,
  });
  Future<CustomerEntity> getCustomerById(String customerId);
  Future<CustomerEntity> updateCustomer(CustomerEntity customer);
  Future<bool> deleteCustomer(String customerId);
}
