import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/get_customer_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'customer_repository.mock.dart';

void main() {
  late CustomerRepositoryMock mockRepository;
  late GetCustomerUsecase usecase;

  setUp(() {
    mockRepository = CustomerRepositoryMock();
    usecase = GetCustomerUsecase(customerRepository: mockRepository);
  });

  const customerId = 'customer123';
  const shopId = 'shop123';

  final expectedCustomer = const CustomerEntity(
    customerId: customerId,
    name: 'John Doe',
    phone: '9876543210',
    email: 'john@email.com',
    address: 'Kathmandu, Nepal',
    currentBalance: 1000.0,
    totalSpent: 5000.0,
    shopId: shopId,
  );

  test('should get customer by id successfully and return Right(CustomerEntity)', () async {
    // Arrange
    when(
      () => mockRepository.getCustomerById(customerId),
    ).thenAnswer((_) async => Right(expectedCustomer));

    // Act
    final result = await usecase(const GetCustomerParams(customerId: customerId));

    // Assert
    expect(result, Right(expectedCustomer));
    verify(() => mockRepository.getCustomerById(customerId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Left(Failure) when getting customer fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Customer not found');
    when(
      () => mockRepository.getCustomerById(customerId),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(const GetCustomerParams(customerId: customerId));

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.getCustomerById(customerId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle empty customer id', () async {
    // Arrange
    const emptyCustomerId = '';
    final failure = ApiFailure(message: 'Invalid customer ID');
    when(
      () => mockRepository.getCustomerById(emptyCustomerId),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(const GetCustomerParams(customerId: emptyCustomerId));

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.getCustomerById(emptyCustomerId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  tearDown(() {
    reset(mockRepository);
  });
} 