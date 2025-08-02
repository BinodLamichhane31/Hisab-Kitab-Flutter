import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/delete_customer_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'customer_repository.mock.dart';

void main() {
  late CustomerRepositoryMock mockRepository;
  late DeleteCustomerUsecase usecase;

  setUp(() {
    mockRepository = CustomerRepositoryMock();
    usecase = DeleteCustomerUsecase(customerRepository: mockRepository);
  });

  const customerId = 'customer123';

  test('should delete customer successfully and return Right(void)', () async {
    // Arrange
    when(
      () => mockRepository.deleteCustomer(customerId),
    ).thenAnswer((_) async => const Right(true));

    // Act
    final result = await usecase(const DeleteCustomerParams(customerId: customerId));

    // Assert
    expect(result, const Right(true));
    verify(() => mockRepository.deleteCustomer(customerId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Left(Failure) when deleting customer fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Failed to delete customer');
    when(
      () => mockRepository.deleteCustomer(customerId),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(const DeleteCustomerParams(customerId: customerId));

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.deleteCustomer(customerId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle empty customer id', () async {
    // Arrange
    const emptyCustomerId = '';
    final failure = ApiFailure(message: 'Invalid customer ID');
    when(
      () => mockRepository.deleteCustomer(emptyCustomerId),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(const DeleteCustomerParams(customerId: emptyCustomerId));

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.deleteCustomer(emptyCustomerId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle customer not found scenario', () async {
    // Arrange
    const nonExistentCustomerId = 'non-existent-customer';
    final failure = ApiFailure(message: 'Customer not found');
    when(
      () => mockRepository.deleteCustomer(nonExistentCustomerId),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(const DeleteCustomerParams(customerId: nonExistentCustomerId));

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.deleteCustomer(nonExistentCustomerId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle successful deletion with false result', () async {
    // Arrange
    when(
      () => mockRepository.deleteCustomer(customerId),
    ).thenAnswer((_) async => const Right(false));

    // Act
    final result = await usecase(const DeleteCustomerParams(customerId: customerId));

    // Assert
    expect(result, const Right(false));
    verify(() => mockRepository.deleteCustomer(customerId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  tearDown(() {
    reset(mockRepository);
  });
} 