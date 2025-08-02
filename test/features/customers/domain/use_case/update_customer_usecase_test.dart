import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/update_customer_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'customer_repository.mock.dart';

void main() {
  late CustomerRepositoryMock mockRepository;
  late UpdateCustomerUsecase usecase;

  setUp(() {
    mockRepository = CustomerRepositoryMock();
    usecase = UpdateCustomerUsecase(customerRepository: mockRepository);
  });

  const customerId = 'customer123';
  const shopId = 'shop123';

  final customerToUpdate = const CustomerEntity(
    customerId: customerId,
    name: 'John Doe Updated',
    phone: '9876543210',
    email: 'john.updated@email.com',
    address: 'Pokhara, Nepal',
    currentBalance: 1500.0,
    totalSpent: 6000.0,
    shopId: shopId,
  );

  final updatedCustomer = const CustomerEntity(
    customerId: customerId,
    name: 'John Doe Updated',
    phone: '9876543210',
    email: 'john.updated@email.com',
    address: 'Pokhara, Nepal',
    currentBalance: 1500.0,
    totalSpent: 6000.0,
    shopId: shopId,
  );

  test(
    'should update customer successfully and return Right(CustomerEntity)',
    () async {
      // Arrange
      when(
        () => mockRepository.updateCustomer(customerToUpdate),
      ).thenAnswer((_) async => Right(updatedCustomer));

      // Act
      final result = await usecase(
        UpdateCustomerParams(customer: customerToUpdate),
      );

      // Assert
      expect(result, Right(updatedCustomer));
      verify(() => mockRepository.updateCustomer(customerToUpdate)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Left(Failure) when updating customer fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Failed to update customer');
    when(
      () => mockRepository.updateCustomer(customerToUpdate),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(
      UpdateCustomerParams(customer: customerToUpdate),
    );

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.updateCustomer(customerToUpdate)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle customer with null customerId', () async {
    // Arrange
    final customerWithoutId = const CustomerEntity(
      name: 'John Doe Updated',
      phone: '9876543210',
      email: 'john.updated@email.com',
      address: 'Pokhara, Nepal',
      currentBalance: 1500.0,
      totalSpent: 6000.0,
      shopId: shopId,
    );

    final failure = ApiFailure(message: 'Customer ID is required');
    when(
      () => mockRepository.updateCustomer(customerWithoutId),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(
      UpdateCustomerParams(customer: customerWithoutId),
    );

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.updateCustomer(customerWithoutId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle customer with empty name', () async {
    // Arrange
    final customerWithEmptyName = const CustomerEntity(
      customerId: customerId,
      name: '',
      phone: '9876543210',
      email: 'john.updated@email.com',
      address: 'Pokhara, Nepal',
      currentBalance: 1500.0,
      totalSpent: 6000.0,
      shopId: shopId,
    );

    final failure = ApiFailure(message: 'Customer name cannot be empty');
    when(
      () => mockRepository.updateCustomer(customerWithEmptyName),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(
      UpdateCustomerParams(customer: customerWithEmptyName),
    );

    // Assert
    expect(result, Left(failure));
    verify(
      () => mockRepository.updateCustomer(customerWithEmptyName),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  tearDown(() {
    reset(mockRepository);
  });
}
