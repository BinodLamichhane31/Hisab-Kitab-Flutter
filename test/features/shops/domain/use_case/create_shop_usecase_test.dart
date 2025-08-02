import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/shops/domain/use_case/create_shop_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'shop_repository.mock.dart';

void main() {
  late ShopRepositoryMock mockRepository;
  late CreateShopUsecase usecase;

  setUp(() {
    mockRepository = ShopRepositoryMock();
    usecase = CreateShopUsecase(shopRepository: mockRepository);
  });

  const createShopParams = CreateShopParams(
    shopName: 'My Shop',
    address: 'Kathmandu, Nepal',
    contactNumber: '9876543210',
  );

  test('should create shop successfully and return Right(void)', () async {
    // Arrange
    when(
      () => mockRepository.createShop(
        createShopParams.shopName,
        createShopParams.address,
        createShopParams.contactNumber,
      ),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(createShopParams);

    // Assert
    expect(result, const Right(null));
    verify(
      () => mockRepository.createShop(
        createShopParams.shopName,
        createShopParams.address,
        createShopParams.contactNumber,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Left(Failure) when creating shop fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Failed to create shop');
    when(
      () => mockRepository.createShop(
        createShopParams.shopName,
        createShopParams.address,
        createShopParams.contactNumber,
      ),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(createShopParams);

    // Assert
    expect(result, Left(failure));
    verify(
      () => mockRepository.createShop(
        createShopParams.shopName,
        createShopParams.address,
        createShopParams.contactNumber,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle shop creation with null address and contact', () async {
    // Arrange
    const paramsWithNulls = CreateShopParams(
      shopName: 'Simple Shop',
      address: null,
      contactNumber: null,
    );

    when(
      () => mockRepository.createShop(
        paramsWithNulls.shopName,
        paramsWithNulls.address,
        paramsWithNulls.contactNumber,
      ),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(paramsWithNulls);

    // Assert
    expect(result, const Right(null));
    verify(
      () => mockRepository.createShop(
        paramsWithNulls.shopName,
        paramsWithNulls.address,
        paramsWithNulls.contactNumber,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle initial params correctly', () {
    // Arrange & Act
    const initialParams = CreateShopParams.initial();

    // Assert
    expect(initialParams.shopName, '_empty.string');
    expect(initialParams.address, null);
    expect(initialParams.contactNumber, null);
  });

  test('should handle empty shop name', () async {
    // Arrange
    const paramsWithEmptyName = CreateShopParams(
      shopName: '',
      address: 'Kathmandu, Nepal',
      contactNumber: '9876543210',
    );

    final failure = ApiFailure(message: 'Shop name cannot be empty');
    when(
      () => mockRepository.createShop(
        paramsWithEmptyName.shopName,
        paramsWithEmptyName.address,
        paramsWithEmptyName.contactNumber,
      ),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(paramsWithEmptyName);

    // Assert
    expect(result, Left(failure));
    verify(
      () => mockRepository.createShop(
        paramsWithEmptyName.shopName,
        paramsWithEmptyName.address,
        paramsWithEmptyName.contactNumber,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  tearDown(() {
    reset(mockRepository);
  });
}
