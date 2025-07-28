import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/notification/domain/entity/notification_entity.dart';
import 'package:hisab_kitab/features/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:hisab_kitab/features/notification/domain/use_case/listen_for_notifications_usecase.dart';
import 'package:hisab_kitab/features/notification/domain/use_case/mark_all_as_read_usecase.dart';
import 'package:hisab_kitab/features/notification/domain/use_case/mark_as_read_usecase.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_event.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_state.dart';

class NotificationViewModel extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUsecase _getNotificationsUsecase;
  final MarkAsReadUsecase _markAsReadUsecase;
  final MarkAllAsReadUsecase _markAllAsReadUsecase;
  final ListenForNotificationsUsecase _listenForNotificationsUsecase;
  StreamSubscription? _notificationSubscription;

  NotificationViewModel({
    required GetNotificationsUsecase getNotificationsUsecase,
    required MarkAsReadUsecase markAsReadUsecase,
    required MarkAllAsReadUsecase markAllAsReadUsecase,
    required ListenForNotificationsUsecase listenForNotificationsUsecase,
  }) : _getNotificationsUsecase = getNotificationsUsecase,
       _markAsReadUsecase = markAsReadUsecase,
       _markAllAsReadUsecase = markAllAsReadUsecase,
       _listenForNotificationsUsecase = listenForNotificationsUsecase,
       super(NotificationState.initial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllAsRead);
    on<NotificationReceived>(_onNotificationReceived);

    _startListening();
  }

  void _startListening() {
    _notificationSubscription?.cancel();
    _notificationSubscription = _listenForNotificationsUsecase().listen((
      either,
    ) {
      either.fold(
        (failure) =>
            print("Error listening to notifications: ${failure.message}"),
        (notification) {
          add(NotificationReceived(notification));
        },
      );
    });
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotificationStatus.loading));
    final result = await _getNotificationsUsecase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: data.notifications,
          unreadCount: data.unreadCount,
        ),
      ),
    );
  }

  Future<void> _onMarkAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _markAsReadUsecase(event.notificationId);
    result.fold((failure) {}, (_) {
      final updatedList =
          state.notifications.map((n) {
            if (n.id == event.notificationId) {
              return NotificationEntity(
                id: n.id,
                message: n.message,
                type: n.type,
                link: n.link,
                isRead: true,
                createdAt: n.createdAt,
              );
            }
            return n;
          }).toList();

      emit(
        state.copyWith(
          notifications: updatedList,
          unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
        ),
      );
    });
  }

  Future<void> _onMarkAllAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _markAllAsReadUsecase();
    result.fold(
      (failure) {
        print('Notification view model on mark all as read: $failure');
      },
      (_) {
        final updatedList =
            state.notifications.map((n) {
              return NotificationEntity(
                id: n.id,
                message: n.message,
                type: n.type,
                link: n.link,
                isRead: true,
                createdAt: n.createdAt,
              );
            }).toList();

        emit(state.copyWith(notifications: updatedList, unreadCount: 0));
      },
    );
  }

  void _onNotificationReceived(
    NotificationReceived event,
    Emitter<NotificationState> emit,
  ) {
    emit(
      state.copyWith(
        notifications: [event.notification, ...state.notifications],
        unreadCount: state.unreadCount + 1,
      ),
    );
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
