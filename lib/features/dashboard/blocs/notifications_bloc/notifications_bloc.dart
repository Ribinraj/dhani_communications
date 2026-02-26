import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/dashboard/models/notification_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:meta/meta.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final Apprepo repository;
  List<NotificationModel> _notifications = [];

  NotificationsBloc({required this.repository}) : super(NotificationsInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<MarkNotificationReadEvent>(_onMarkNotificationRead);
  }

  FutureOr<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoadingState());
    try {
      final response = await repository.getNotifications();
      if (!response.error && response.status == 200 && response.data != null) {
        _notifications = response.data!;
        emit(NotificationsSuccessState(notifications: _notifications));
      } else {
        emit(NotificationsErrorState(message: response.message));
      }
    } catch (e) {
      emit(NotificationsErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onMarkNotificationRead(
    MarkNotificationReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(MarkNotificationReadLoadingState(
      notifications: _notifications,
      notificationId: event.notificationId,
    ));
    try {
      final response = await repository.updateNotification(
        notificationId: event.notificationId,
      );
      if (!response.error && response.status == 200) {
        // Update local notifications list
        _notifications = _notifications.map((notification) {
          if (notification.notificationId == event.notificationId) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList();
        emit(MarkNotificationReadSuccessState(
          notifications: _notifications,
          message: response.message,
        ));
      } else {
        emit(MarkNotificationReadErrorState(
          notifications: _notifications,
          message: response.message,
        ));
      }
    } catch (e) {
      emit(MarkNotificationReadErrorState(
        notifications: _notifications,
        message: e.toString(),
      ));
    }
  }
}
