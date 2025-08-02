import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopeSensorService {
  static const double _rotationThreshold = 2.0; // radians per second
  static const int _rotationTimeWindow = 1000; // milliseconds
  static const int _rotationCountThreshold =
      3; // Number of rotations to trigger

  StreamController<RotationEvent>? _rotationController;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  final List<DateTime> _rotationTimes = [];
  bool _isListening = false;
  bool _isSupported = true;

  Stream<RotationEvent> get rotationStream {
    _rotationController ??= StreamController<RotationEvent>.broadcast();
    return _rotationController!.stream;
  }

  Future<bool> _checkPlatformSupport() async {
    // Check if we're on a supported platform
    if (kIsWeb) {
      _isSupported = false;
      return false;
    }

    try {
      // Test if gyroscope is available
      await gyroscopeEventStream().first.timeout(
        const Duration(seconds: 1),
        onTimeout: () => throw Exception('Gyroscope not available'),
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
      print('Gyroscope sensor not supported on this platform');
      return;
    }

    _isListening = true;
    try {
      _gyroscopeSubscription = gyroscopeEventStream().listen(
        _onGyroscopeEvent,
        onError: (error) {
          print('Gyroscope error: $error');
          _isListening = false;
        },
      );
    } catch (e) {
      print('Failed to start gyroscope: $e');
      _isListening = false;
    }
  }

  void stopListening() {
    _isListening = false;
    _gyroscopeSubscription?.cancel();
    _gyroscopeSubscription = null;
  }

  void _onGyroscopeEvent(GyroscopeEvent event) {
    if (!_isListening) return;

    final rotationSpeed = _calculateRotationSpeed(event);

    if (rotationSpeed > _rotationThreshold) {
      _handleRotation();
    }
  }

  double _calculateRotationSpeed(GyroscopeEvent event) {
    // Calculate the magnitude of rotation speed
    final x = event.x;
    final y = event.y;
    final z = event.z;

    return sqrt(x * x + y * y + z * z);
  }

  void _handleRotation() {
    final now = DateTime.now();

    // Add current rotation time
    _rotationTimes.add(now);

    // Remove old rotation times outside the time window
    _rotationTimes.removeWhere(
      (time) => now.difference(time).inMilliseconds > _rotationTimeWindow,
    );

    // Check if we have enough rotations in the time window
    if (_rotationTimes.length >= _rotationCountThreshold) {
      _triggerRotationEvent();
      _rotationTimes.clear(); // Reset for next detection
    }
  }

  Future<void> _triggerRotationEvent() async {
    try {
      // Provide haptic feedback
      await Haptics.vibrate(HapticsType.light);
    } catch (e) {
      print('Haptic feedback error: $e');
    }

    // Emit rotation event
    _rotationController?.add(RotationEvent());
  }

  bool get isSupported => _isSupported;

  void dispose() {
    stopListening();
    _rotationController?.close();
    _rotationController = null;
  }
}

class RotationEvent {
  final DateTime timestamp = DateTime.now();

  @override
  String toString() => 'RotationEvent(timestamp: $timestamp)';
}
