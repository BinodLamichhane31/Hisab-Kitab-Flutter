import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/services/gyroscope_sensor_service.dart';

import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';
import 'package:hisab_kitab/features/shops/presentation/view/widget/shop_switcher.dart'
    hide ShopSwitchAnimation;

class RotationService {
  final GyroscopeSensorService _gyroscopeSensorService;
  final SessionCubit _sessionCubit;
  StreamSubscription<RotationEvent>? _rotationSubscription;
  bool _isListening = false;
  BuildContext? _currentContext;

  RotationService({
    required GyroscopeSensorService gyroscopeSensorService,
    required SessionCubit sessionCubit,
  }) : _gyroscopeSensorService = gyroscopeSensorService,
       _sessionCubit = sessionCubit;

  Future<void> startListening(BuildContext context) async {
    if (_isListening) return;

    // Check if rotation detection is supported on this platform
    if (!_gyroscopeSensorService.isSupported) {
      print('Rotation detection not supported on this platform');
      return;
    }

    _isListening = true;
    _currentContext = context;

    try {
      await _gyroscopeSensorService.startListening();
      _rotationSubscription = _gyroscopeSensorService.rotationStream.listen(
        _onRotationDetected,
      );
    } catch (e) {
      print('Failed to start rotation detection: $e');
      _isListening = false;
    }
  }

  void stopListening() {
    if (!_isListening) return;
    _isListening = false;

    _rotationSubscription?.cancel();
    _rotationSubscription = null;
    _gyroscopeSensorService.stopListening();
    _currentContext = null;
  }

  void _onRotationDetected(RotationEvent event) {
    final currentState = _sessionCubit.state;
    final shops = currentState.shops;
    final activeShop = currentState.activeShop;

    if (shops.isEmpty) {
      _showMessage('No shops available');
      return;
    }

    if (shops.length == 1) {
      _showMessage(
        'Only one shop available. Add more shops to use rotation-to-switch.',
      );
      return;
    }

    if (shops.length == 2) {
      _switchToOtherShop(shops, activeShop);
      return;
    }

    // More than 2 shops - show bottom sheet
    _showShopSwitcherBottomSheet();
  }

  void _switchToOtherShop(List<ShopEntity> shops, ShopEntity? activeShop) {
    // Find the other shop (not the active one)
    final otherShop = shops.firstWhere(
      (shop) => shop.shopId != activeShop?.shopId,
      orElse: () => shops.first,
    );

    if (otherShop != activeShop && _currentContext != null) {
      // Direct shop switch without animation
      _sessionCubit.switchShop(otherShop, _currentContext!, otherShop.shopName);
    }
  }

  void _showShopSwitcherBottomSheet() {
    if (_currentContext == null) return;

    final currentState = _sessionCubit.state;
    final shopSwitcher = ShopSwitcherWidget();
    shopSwitcher.showShopSwitcherBottomSheet(
      _currentContext!,
      currentState.shops,
      currentState.activeShop,
    );
  }

  void _showMessage(String message) {
    if (_currentContext != null) {
      showMySnackBar(
        context: _currentContext!,
        message: message,
        color: Colors.blue,
      );
    }
  }

  bool get isSupported => _gyroscopeSensorService.isSupported;

  void dispose() {
    stopListening();
    _gyroscopeSensorService.dispose();
  }
}
