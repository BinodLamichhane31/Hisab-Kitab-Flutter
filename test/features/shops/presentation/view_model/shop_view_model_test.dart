import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_view_model.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_state.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_event.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

void main() {
  group('ShopViewModel', () {
    test('initial state is correct', () {
      expect(const ShopState.initial(), const ShopState.initial());
    });

    test('initial state properties are correct', () {
      final state = const ShopState.initial();
      expect(state.shops, []);
      expect(state.isLoading, false);
      expect(state.errorMessage, null);
      expect(state.successMessage, null);
      expect(state.shopCreationSuccess, false);
    });

    test('state copyWith works correctly', () {
      final initialState = const ShopState.initial();

      // Test with shops
      final shops = [
        ShopEntity(
          shopId: '1',
          shopName: 'Test Shop',
          address: 'Test Address',
          contactNumber: '1234567890',
          ownerId: 'user1',
        ),
      ];

      final updatedState = initialState.copyWith(
        shops: shops,
        isLoading: true,
        errorMessage: () => 'Test error',
        successMessage: () => 'Test success',
        shopCreationSuccess: true,
      );

      expect(updatedState.shops, shops);
      expect(updatedState.isLoading, true);
      expect(updatedState.errorMessage, 'Test error');
      expect(updatedState.successMessage, 'Test success');
      expect(updatedState.shopCreationSuccess, true);
    });

    test('state equality works correctly', () {
      final state1 = const ShopState.initial();
      final state2 = const ShopState.initial();
      final state3 = const ShopState.initial().copyWith(isLoading: true);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('ShopEntity properties are correct', () {
      final shop = ShopEntity(
        shopId: '1',
        shopName: 'Test Shop',
        address: 'Test Address',
        contactNumber: '1234567890',
        ownerId: 'user1',
      );

      expect(shop.shopId, '1');
      expect(shop.shopName, 'Test Shop');
      expect(shop.address, 'Test Address');
      expect(shop.contactNumber, '1234567890');
      expect(shop.ownerId, 'user1');
    });

    test('ShopEvent classes can be instantiated', () {
      // Test LoadShopsEvent
      expect(LoadShopsEvent(), isA<LoadShopsEvent>());

      // Test CreateShopEvent
      expect(
        CreateShopEvent(
          shopName: 'Test Shop',
          address: 'Test Address',
          contactNumber: '1234567890',
        ),
        isA<CreateShopEvent>(),
      );
    });

    test('CreateShopEvent properties are correct', () {
      final event = CreateShopEvent(
        shopName: 'Test Shop',
        address: 'Test Address',
        contactNumber: '1234567890',
      );

      expect(event.shopName, 'Test Shop');
      expect(event.address, 'Test Address');
      expect(event.contactNumber, '1234567890');
    });

    test('ShopEntity equality works correctly', () {
      final shop1 = ShopEntity(
        shopId: '1',
        shopName: 'Test Shop',
        address: 'Test Address',
        contactNumber: '1234567890',
        ownerId: 'user1',
      );

      final shop2 = ShopEntity(
        shopId: '1',
        shopName: 'Test Shop',
        address: 'Test Address',
        contactNumber: '1234567890',
        ownerId: 'user1',
      );

      final shop3 = ShopEntity(
        shopId: '2',
        shopName: 'Different Shop',
        address: 'Different Address',
        contactNumber: '0987654321',
        ownerId: 'user2',
      );

      expect(shop1, equals(shop2));
      expect(shop1, isNot(equals(shop3)));
    });
  });
}
