import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/get_customers_by_shop_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'customer_repository.mock.dart';

void main() {
  late CustomerRepositoryMock mockRepository;
  late GetCustomersByShopUsecase usecase;

  setUp(() {
    mockRepository = CustomerRepositoryMock();
    usecase = GetCustomersByShopUsecase(customerRepository: mockRepository);
  });

  const shopId = 'shop123';
  const search = 'John';

  final expectedCustomers = [
    const CustomerEntity(
      customerId: 'customer1',
      name: 'John Doe',
      phone: '9876543210',
      email: 'john@email.com',
      address: 'Kathmandu, Nepal',
      currentBalance: 1000.0,
      totalSpent: 5000.0,
      shopId: shopId,
    ),
    const CustomerEntity(
      customerId: 'customer2',
      name: 'Jane Smith',
      phone: '9876543211',
      email: 'jane@email.com',
      address: 'Pokhara, Nepal',
      currentBalance: 2000.0,
      totalSpent: 8000.0,
      shopId: shopId,
    ),
  ];

  test(
    'should get customers by shop successfully and return Right(List<CustomerEntity>)',
    () async {
      // Arrange
      when(
        () => mockRepository.getCustomerByShop(shopId, search: null),
      ).thenAnswer((_) async => Right(expectedCustomers));

      // Act
      final result = await usecase(
        const GetCustomersByShopParams(shopId: shopId),
      );

      // Assert
      expect(result, Right(expectedCustomers));
      verify(
        () => mockRepository.getCustomerByShop(shopId, search: null),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should get customers by shop with search successfully', () async {
    // Arrange
    when(
      () => mockRepository.getCustomerByShop(shopId, search: search),
    ).thenAnswer((_) async => Right(expectedCustomers));

    // Act
    final result = await usecase(
      GetCustomersByShopParams(shopId: shopId, search: search),
    );

    // Assert
    expect(result, Right(expectedCustomers));
    verify(
      () => mockRepository.getCustomerByShop(shopId, search: search),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Left(Failure) when getting customers fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Failed to get customers');
    when(
      () => mockRepository.getCustomerByShop(shopId, search: null),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(
      const GetCustomersByShopParams(shopId: shopId),
    );

    // Assert
    expect(result, Left(failure));
    verify(
      () => mockRepository.getCustomerByShop(shopId, search: null),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  tearDown(() {
    reset(mockRepository);
  });
}
