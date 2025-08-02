import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/core/services/gyroscope_sensor_service.dart';
import 'package:hisab_kitab/features/transactions/presentation/view/transaction_view.dart';

class GyroscopeTransactionService {
  final GyroscopeSensorService _gyroscopeSensorService;
  StreamSubscription<RotationEvent>? _rotationSubscription;
  bool _isListening = false;
  BuildContext? _currentContext;

  GyroscopeTransactionService({
    required GyroscopeSensorService gyroscopeSensorService,
  }) : _gyroscopeSensorService = gyroscopeSensorService;

  Future<void> startListening(BuildContext context) async {
    if (_isListening) return;

    // Check if rotation detection is supported on this platform
    if (!_gyroscopeSensorService.isSupported) {
      print('Gyroscope sensor not supported on this platform');
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
    if (_currentContext == null) return;

    // Navigate to transaction view
    Navigator.of(
      _currentContext!,
    ).push(MaterialPageRoute(builder: (_) => const TransactionsView()));

    // Show success message
    _showMessage('Navigated to Transactions via gyroscope!');
  }

  void _showMessage(String message) {
    if (_currentContext != null) {
      showMySnackBar(
        context: _currentContext!,
        message: message,
        color: Colors.green,
      );
    }
  }

  bool get isSupported => _gyroscopeSensorService.isSupported;

  void dispose() {
    stopListening();
    _gyroscopeSensorService.dispose();
  }
}
