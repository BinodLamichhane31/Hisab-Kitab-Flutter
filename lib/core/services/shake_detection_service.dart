import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetectionService {
  static const double _shakeThreshold = 12.0; // Adjust sensitivity
  static const int _shakeTimeWindow = 500; // milliseconds
  static const int _shakeCountThreshold = 2; // Number of shakes to trigger

  StreamController<ShakeEvent>? _shakeController;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final List<DateTime> _shakeTimes = [];
  bool _isListening = false;
  bool _isSupported = true;

  Stream<ShakeEvent> get shakeStream {
    _shakeController ??= StreamController<ShakeEvent>.broadcast();
    return _shakeController!.stream;
  }

  Future<bool> _checkPlatformSupport() async {
    // Check if we're on a supported platform
    if (kIsWeb) {
      _isSupported = false;
      return false;
    }

    try {
      // Test if accelerometer is available
      await accelerometerEventStream().first.timeout(
        const Duration(seconds: 1),
        onTimeout: () => throw Exception('Accelerometer not available'),
      );
      return true;
    } catch (e) {
      _isSupported = false;
      return false;
    }
  }

  Future<void> startListening() async {
    if (_isListening) return;

    // Check platform support first
    final isSupported = await _checkPlatformSupport();
    if (!isSupported) {
      print('Shake detection not supported on this platform');
      return;
    }

    _isListening = true;
    try {
      _accelerometerSubscription = accelerometerEventStream().listen(
        _onAccelerometerEvent,
        onError: (error) {
          print('Accelerometer error: $error');
          _isListening = false;
        },
      );
    } catch (e) {
      print('Failed to start accelerometer: $e');
      _isListening = false;
    }
  }

  void stopListening() {
    _isListening = false;
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    if (!_isListening) return;

    final acceleration = _calculateAcceleration(event);

    if (acceleration > _shakeThreshold) {
      _handleShake();
    }
  }

  double _calculateAcceleration(AccelerometerEvent event) {
    // Calculate the magnitude of acceleration
    final x = event.x;
    final y = event.y;
    final z = event.z;

    return sqrt(x * x + y * y + z * z);
  }

  void _handleShake() {
    final now = DateTime.now();

    // Add current shake time
    _shakeTimes.add(now);

    // Remove old shake times outside the time window
    _shakeTimes.removeWhere(
      (time) => now.difference(time).inMilliseconds > _shakeTimeWindow,
    );

    // Check if we have enough shakes in the time window
    if (_shakeTimes.length >= _shakeCountThreshold) {
      _triggerShakeEvent();
      _shakeTimes.clear(); // Reset for next detection
    }
  }

  Future<void> _triggerShakeEvent() async {
    try {
      // Provide haptic feedback
      await Haptics.vibrate(HapticsType.medium);
    } catch (e) {
      print('Haptic feedback error: $e');
    }

    // Emit shake event
    _shakeController?.add(ShakeEvent());
  }

  bool get isSupported => _isSupported;

  void dispose() {
    stopListening();
    _shakeController?.close();
    _shakeController = null;
  }
}

class ShakeEvent {
  final DateTime timestamp = DateTime.now();

  @override
  String toString() => 'ShakeEvent(timestamp: $timestamp)';
}
