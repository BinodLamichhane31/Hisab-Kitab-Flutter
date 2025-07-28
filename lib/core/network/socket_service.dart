import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/features/notification/data/model/notification_api_model.dart';

class SocketService {
  // Singleton setup
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  IO.Socket? _socket;
  final StreamController<NotificationApiModel> _notificationController =
      StreamController.broadcast();

  Stream<NotificationApiModel> get notificationStream =>
      _notificationController.stream;

  void connect(String token, String userId) {
    if (_socket?.connected ?? false) {
      disconnect();
    }

    _socket = IO.io(
      ApiEndpoints.serverAddress,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print('Socket connected: ${_socket!.id}');
      _socket!.emit('join_room', userId);
    });

    _socket!.on('new_notification', (data) {
      print('New notification received: $data');
      if (data is Map<String, dynamic>) {
        _notificationController.add(NotificationApiModel.fromJson(data));
      }
    });

    _socket!.onDisconnect((_) => print('Socket disconnected'));
    _socket!.onError((error) => print('Socket error: $error'));
  }

  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }
}
