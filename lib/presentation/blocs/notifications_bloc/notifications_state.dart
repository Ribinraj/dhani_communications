part of 'notifications_bloc.dart';

@immutable
sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsLoadingState extends NotificationsState {}

final class NotificationsSuccessState extends NotificationsState {
  final List<NotificationModel> notifications;

  NotificationsSuccessState({required this.notifications});
}

final class NotificationsErrorState extends NotificationsState {
  final String message;

  NotificationsErrorState({required this.message});
}

// States for marking notification as read
final class MarkNotificationReadLoadingState extends NotificationsState {
  final List<NotificationModel> notifications;
  final int notificationId;

  MarkNotificationReadLoadingState({
    required this.notifications,
    required this.notificationId,
  });
}

final class MarkNotificationReadSuccessState extends NotificationsState {
  final List<NotificationModel> notifications;
  final String message;

  MarkNotificationReadSuccessState({
    required this.notifications,
    required this.message,
  });
}

final class MarkNotificationReadErrorState extends NotificationsState {
  final List<NotificationModel> notifications;
  final String message;

  MarkNotificationReadErrorState({
    required this.notifications,
    required this.message,
  });
}
