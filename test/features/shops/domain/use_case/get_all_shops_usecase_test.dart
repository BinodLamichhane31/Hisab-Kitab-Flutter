import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';
import 'package:hisab_kitab/features/shops/domain/use_case/get_all_shops_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'shop_repository.mock.dart';

void main() {
  late ShopRepositoryMock mockRepository;
  late GetAllShopsUsecase usecase;

  setUp(() {
    mockRepository = ShopRepositoryMock();
    usecase = GetAllShopsUsecase(shopRepository: mockRepository);
  });

  final expectedShops = [
    const ShopEntity(
      shopId: 'shop1',
      shopName: 'My First Shop',
      address: 'Kathmandu, Nepal',
      contactNumber: '9876543210',
      ownerId: 'user123',
    ),
    const ShopEntity(
      shopId: 'shop2',
      shopName: 'My Second Shop',
      address: 'Pokhara, Nepal',
      contactNumber: '9876543211',
      ownerId: 'user123',
    ),
    const ShopEntity(
      shopId: 'shop3',
      shopName: 'My Third Shop',
      address: 'Biratnagar, Nepal',
      contactNumber: '9876543212',
      ownerId: 'user123',
    ),
  ];

  test(
    'should get all shops successfully and return Right(List<ShopEntity>)',
    () async {
      // Arrange
      when(
        () => mockRepository.getShops(),
      ).thenAnswer((_) async => Right(expectedShops));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Right(expectedShops));
      verify(() => mockRepository.getShops()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Left(Failure) when getting shops fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Failed to get shops');
    when(
      () => mockRepository.getShops(),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.getShops()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return empty list when no shops found', () async {
    // Arrange
    when(
      () => mockRepository.getShops(),
    ).thenAnswer((_) async => const Right(<ShopEntity>[]));

    // Act
    final result = await usecase();

    // Assert
    expect(result, const Right(<ShopEntity>[]));
    verify(() => mockRepository.getShops()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle shops with null address and contact', () async {
    // Arrange
    final shopsWithNulls = [
      const ShopEntity(
        shopId: 'shop1',
        shopName: 'Shop with null fields',
        address: null,
        contactNumber: null,
        ownerId: 'user123',
      ),
    ];

    when(
      () => mockRepository.getShops(),
    ).thenAnswer((_) async => Right(shopsWithNulls));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Right(shopsWithNulls));
    verify(() => mockRepository.getShops()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle network error', () async {
    // Arrange
    final failure = ApiFailure(message: 'Network error occurred');
    when(
      () => mockRepository.getShops(),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.getShops()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  tearDown(() {
    reset(mockRepository);
  });
}
