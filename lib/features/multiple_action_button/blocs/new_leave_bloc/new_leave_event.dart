part of 'new_leave_bloc.dart';

@immutable
sealed class NewLeaveEvent {}

class SubmitNewLeaveEvent extends NewLeaveEvent {
  final NewLeaveRequestModel leave;

  SubmitNewLeaveEvent({required this.leave});
}
