import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/shops/domain/use_case/switch_shop_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'shop_repository.mock.dart';

void main() {
  late ShopRepositoryMock mockRepository;
  late SwitchShopUsecase usecase;

  setUp(() {
    mockRepository = ShopRepositoryMock();
    usecase = SwitchShopUsecase(shopRepository: mockRepository);
  });

  const shopId = 'shop123';

  test('should switch shop successfully and return Right(true)', () async {
    // Arrange
    when(
      () => mockRepository.switchShop(shopId),
    ).thenAnswer((_) async => const Right(true));

    // Act
    final result = await usecase(const SwitchShopParams(shopId: shopId));

    // Assert
    expect(result, const Right(true));
    verify(() => mockRepository.switchShop(shopId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Left(Failure) when switching shop fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Failed to switch shop');
    when(
      () => mockRepository.switchShop(shopId),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(const SwitchShopParams(shopId: shopId));

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.switchShop(shopId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle empty shop id', () async {
    // Arrange
    const emptyShopId = '';
    final failure = ApiFailure(message: 'Invalid shop ID');
    when(
      () => mockRepository.switchShop(emptyShopId),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(const SwitchShopParams(shopId: emptyShopId));

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.switchShop(emptyShopId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle shop not found scenario', () async {
    // Arrange
    const nonExistentShopId = 'non-existent-shop';
    final failure = ApiFailure(message: 'Shop not found');
    when(
      () => mockRepository.switchShop(nonExistentShopId),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(
      const SwitchShopParams(shopId: nonExistentShopId),
    );

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.switchShop(nonExistentShopId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle successful switch with false result', () async {
    // Arrange
    when(
      () => mockRepository.switchShop(shopId),
    ).thenAnswer((_) async => const Right(false));

    // Act
    final result = await usecase(const SwitchShopParams(shopId: shopId));

    // Assert
    expect(result, const Right(false));
    verify(() => mockRepository.switchShop(shopId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle initial params correctly', () {
    // Arrange & Act
    const initialParams = SwitchShopParams.initial();

    // Assert
    expect(initialParams.shopId, '_empty.string');
  });

  test('should handle network error during switch', () async {
    // Arrange
    final failure = ApiFailure(message: 'Network error occurred');
    when(
      () => mockRepository.switchShop(shopId),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(const SwitchShopParams(shopId: shopId));

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.switchShop(shopId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  tearDown(() {
    reset(mockRepository);
  });
}
