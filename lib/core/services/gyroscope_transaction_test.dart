import 'package:flutter/material.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/services/gyroscope_sensor_service.dart';
import 'package:hisab_kitab/core/services/gyroscope_transaction_service.dart';

class GyroscopeTransactionTestWidget extends StatefulWidget {
  const GyroscopeTransactionTestWidget({super.key});

  @override
  State<GyroscopeTransactionTestWidget> createState() =>
      _GyroscopeTransactionTestWidgetState();
}

class _GyroscopeTransactionTestWidgetState
    extends State<GyroscopeTransactionTestWidget> {
  final GyroscopeSensorService _gyroscopeSensorService =
      serviceLocator<GyroscopeSensorService>();
  final GyroscopeTransactionService _gyroscopeTransactionService =
      serviceLocator<GyroscopeTransactionService>();
  bool _isListening = false;
  List<String> _events = [];

  @override
  void initState() {
    super.initState();
    _setupGyroscopeListener();
  }

  void _setupGyroscopeListener() {
    _gyroscopeSensorService.rotationStream.listen((event) {
      setState(() {
        _events.add(
          '${DateTime.now().toString().substring(11, 19)}: Rotation detected!',
        );
        if (_events.length > 10) {
          _events.removeAt(0);
        }
      });
    });
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      _gyroscopeSensorService.stopListening();
      _gyroscopeTransactionService.stopListening();
      setState(() {
        _isListening = false;
      });
    } else {
      await _gyroscopeSensorService.startListening();
      await _gyroscopeTransactionService.startListening(context);
      setState(() {
        _isListening = true;
      });
    }
  }

  @override
  void dispose() {
    _gyroscopeSensorService.stopListening();
    _gyroscopeTransactionService.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gyroscope Transaction Test'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 64,
                      color: _isListening ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gyroscope Transaction Navigation',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rotate your device to navigate to Transactions',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _toggleListening,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isListening ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        _isListening ? 'Stop Listening' : 'Start Listening',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sensor Status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Supported: ${_gyroscopeSensorService.isSupported ? 'Yes' : 'No'}',
                    ),
                    Text('Listening: ${_isListening ? 'Yes' : 'No'}'),
                    const SizedBox(height: 16),
                    Text(
                      'Recent Events',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: _events.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              _events[index],
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
