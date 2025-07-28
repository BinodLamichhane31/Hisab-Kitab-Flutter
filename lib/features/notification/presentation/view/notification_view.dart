import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/notification/domain/entity/notification_entity.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_event.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_state.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:hisab_kitab/features/products/presentation/view/product_detail_view.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          BlocBuilder<NotificationViewModel, NotificationState>(
            builder: (context, state) {
              return TextButton(
                onPressed:
                    state.unreadCount > 0
                        ? () => context.read<NotificationViewModel>().add(
                          MarkAllNotificationsAsRead(),
                        )
                        : null,
                child: const Text(
                  'Mark all as read',
                  style: TextStyle(color: Colors.orange),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationViewModel, NotificationState>(
        builder: (context, state) {
          if (state.status == NotificationStatus.loading &&
              state.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('You have no notifications.'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationViewModel>().add(LoadNotifications());
            },
            child: ListView.separated(
              itemCount: state.notifications.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                final isUnread = !notification.isRead;
                return Container(
                  color:
                      isUnread
                          ? Colors.orange.withOpacity(0.05)
                          : Colors.transparent,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          isUnread ? Colors.orange : Colors.grey.shade300,
                      child: Icon(
                        _getIconForType(notification.type),
                        color: isUnread ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                    title: Text(
                      notification.message,
                      style: TextStyle(
                        fontWeight:
                            isUnread ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      timeago.format(notification.createdAt),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      if (isUnread) {
                        context.read<NotificationViewModel>().add(
                          MarkNotificationAsRead(notification.id),
                        );
                      }
                      if (notification.link.isNotEmpty &&
                          notification.type == NotificationType.LOW_STOCK) {
                        String url = notification.link;
                        String productId = url.split("/").last;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ProductDetailView(productId: productId),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.LOW_STOCK:
        return Icons.inventory_2_outlined;
      case NotificationType.COLLECTION_OVERDUE:
        return Icons.person_search_outlined;
      case NotificationType.PAYMENT_DUE:
        return Icons.payment_outlined;
      case NotificationType.GENERAL:
        return Icons.notifications_active_outlined;
    }
  }
}
