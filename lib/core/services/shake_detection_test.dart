import 'package:flutter/material.dart';
import 'package:hisab_kitab/core/services/shake_detection_service.dart';

/// Test widget to demonstrate shake detection functionality
/// This can be used for testing the shake detection feature
class ShakeDetectionTestWidget extends StatefulWidget {
  const ShakeDetectionTestWidget({super.key});

  @override
  State<ShakeDetectionTestWidget> createState() =>
      _ShakeDetectionTestWidgetState();
}

class _ShakeDetectionTestWidgetState extends State<ShakeDetectionTestWidget> {
  final ShakeDetectionService _shakeDetectionService = ShakeDetectionService();
  String _lastShakeTime = 'No shake detected yet';
  bool _isSupported = true;

  @override
  void initState() {
    super.initState();
    _initializeShakeDetection();
  }

  Future<void> _initializeShakeDetection() async {
    if (_shakeDetectionService.isSupported) {
      try {
        await _shakeDetectionService.startListening();
        _shakeDetectionService.shakeStream.listen((event) {
          setState(() {
            _lastShakeTime = 'Shake detected at: ${event.timestamp}';
          });
        });
        setState(() {});
      } catch (e) {
        setState(() {
          _isSupported = false;
          _lastShakeTime = 'Error initializing shake detection: $e';
        });
      }
    } else {
      setState(() {
        _isSupported = false;
        _lastShakeTime = 'Shake detection not supported on this platform';
      });
    }
  }

  @override
  void dispose() {
    _shakeDetectionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shake Detection Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isSupported ? Icons.phone_android : Icons.error_outline,
              size: 100,
              color: _isSupported ? Colors.orange : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              _isSupported
                  ? 'Shake your device to test'
                  : 'Not supported on this platform',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              _lastShakeTime,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            if (_isSupported) ...[
              const Text(
                'Instructions:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '• Shake your device to trigger the detection\n'
                  '• You should feel haptic feedback when detected\n'
                  '• The timestamp will update when shake is detected\n'
                  '• This feature is integrated with shop switching',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ),
            ] else ...[
              const Text(
                'Platform Support:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '• iOS: Full support with haptic feedback\n'
                  '• Android: Full support with vibration\n'
                  '• Web: Limited support (no accelerometer)\n'
                  '• Desktop: Limited support (no accelerometer)',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
