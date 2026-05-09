part of 'new_request_bloc.dart';

@immutable
sealed class NewRequestEvent {}

final class SubmitNewRequestEvent extends NewRequestEvent {
  final NewRequestModel request;

  SubmitNewRequestEvent({required this.request});
}
