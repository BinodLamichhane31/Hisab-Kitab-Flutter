import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/core/network/socket_service.dart';
import 'package:hisab_kitab/features/notification/data/model/notification_api_model.dart';

class NotificationRemoteDataSource {
  final ApiService _apiService;
  final SocketService _socketService;

  NotificationRemoteDataSource({
    required ApiService apiService,
    required SocketService socketService,
  }) : _apiService = apiService,
       _socketService = socketService;

  Future<Map<String, dynamic>> getNotifications() async {
    final response = await _apiService.dio.get(ApiEndpoints.notifications);
    return response.data;
  }

  Future<bool> markAsRead(String notificationId) async {
    final response = await _apiService.dio.post(
      '${ApiEndpoints.notifications}/$notificationId/read',
    );
    return response.statusCode == 200;
  }

  Future<bool> markAllAsRead() async {
    final response = await _apiService.dio.post(
      '${ApiEndpoints.notifications}/read-all',
    );
    return response.statusCode == 200;
  }

  Stream<NotificationApiModel> listenForNotifications() {
    return _socketService.notificationStream;
  }

  void disconnectListener() => _socketService.disconnect();
}
