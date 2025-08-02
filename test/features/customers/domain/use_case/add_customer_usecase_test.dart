import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/add_customer_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'customer_repository.mock.dart';

void main() {
  late CustomerRepositoryMock mockRepository;
  late AddCustomerUsecase usecase;

  setUp(() {
    mockRepository = CustomerRepositoryMock();
    usecase = AddCustomerUsecase(customerRepository: mockRepository);
  });

  const addCustomerParams = AddCustomerParams(
    name: 'Binod Lamichhane',
    phone: '9876543210',
    email: 'binod@email.com',
    address: 'Kathmandu, Nepal',
    currentBalance: 1000.0,
    totalSpent: 5000.0,
    shopId: 'shop123',
  );

  final expectedCustomerEntity = CustomerEntity(
    name: addCustomerParams.name,
    phone: addCustomerParams.phone,
    email: addCustomerParams.email,
    address: addCustomerParams.address,
    currentBalance: addCustomerParams.currentBalance,
    totalSpent: addCustomerParams.totalSpent,
    shopId: addCustomerParams.shopId,
  );

  test('should add customer successfully and return Right(void)', () async {
    // Arrange
    when(
      () => mockRepository.addCustomer(expectedCustomerEntity),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(addCustomerParams);

    // Assert
    expect(result, const Right(null));
    verify(() => mockRepository.addCustomer(expectedCustomerEntity)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Left(Failure) when adding customer fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Failed to add customer');
    when(
      () => mockRepository.addCustomer(expectedCustomerEntity),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(addCustomerParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.addCustomer(expectedCustomerEntity)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle initial params correctly', () {
    // Arrange & Act
    const initialParams = AddCustomerParams.initial();

    // Assert
    expect(initialParams.name, '_empty.string');
    expect(initialParams.phone, '_empty.string');
    expect(initialParams.email, '_empty.string');
    expect(initialParams.address, '_empty.string');
    expect(initialParams.currentBalance, 0.0);
    expect(initialParams.totalSpent, 0.0);
    expect(initialParams.shopId, '_empty.string');
  });

  tearDown(() {
    reset(mockRepository);
  });
}
