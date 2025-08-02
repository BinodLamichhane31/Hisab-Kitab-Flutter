import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/services/shake_detection_service.dart';

import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';
import 'package:hisab_kitab/features/shops/presentation/view/widget/shop_switcher.dart'
    hide ShopSwitchAnimation;

class ShopSwitchService {
  final ShakeDetectionService _shakeDetectionService;
  final SessionCubit _sessionCubit;
  StreamSubscription<ShakeEvent>? _shakeSubscription;
  bool _isListening = false;
  BuildContext? _currentContext;

  ShopSwitchService({
    required ShakeDetectionService shakeDetectionService,
    required SessionCubit sessionCubit,
  }) : _shakeDetectionService = shakeDetectionService,
       _sessionCubit = sessionCubit;

  Future<void> startListening(BuildContext context) async {
    if (_isListening) return;

    // Check if shake detection is supported on this platform
    if (!_shakeDetectionService.isSupported) {
      print('Shake detection not supported on this platform');
      return;
    }

    _isListening = true;
    _currentContext = context;

    try {
      await _shakeDetectionService.startListening();
      _shakeSubscription = _shakeDetectionService.shakeStream.listen(
        _onShakeDetected,
      );
    } catch (e) {
      print('Failed to start shake detection: $e');
      _isListening = false;
    }
  }

  void stopListening() {
    if (!_isListening) return;
    _isListening = false;

    _shakeSubscription?.cancel();
    _shakeSubscription = null;
    _shakeDetectionService.stopListening();
    _currentContext = null;
  }

  void _onShakeDetected(ShakeEvent event) {
    final currentState = _sessionCubit.state;
    final shops = currentState.shops;
    final activeShop = currentState.activeShop;

    if (shops.isEmpty) {
      _showMessage('No shops available');
      return;
    }

    if (shops.length == 1) {
      _showMessage(
        'Only one shop available. Add more shops to use shake-to-switch.',
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
        color: Colors.orange,
      );
    }
  }

  bool get isSupported => _shakeDetectionService.isSupported;

  void dispose() {
    stopListening();
    _shakeDetectionService.dispose();
  }
}
