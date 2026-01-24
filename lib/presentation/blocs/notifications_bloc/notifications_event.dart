part of 'notifications_bloc.dart';

@immutable
sealed class NotificationsEvent {}

/// Event to fetch notifications list
class FetchNotificationsEvent extends NotificationsEvent {}

/// Event to mark notification as read
class MarkNotificationReadEvent extends NotificationsEvent {
  final int notificationId;

  MarkNotificationReadEvent({required this.notificationId});
}
