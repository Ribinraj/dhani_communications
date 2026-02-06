part of 'leave_list_bloc.dart';

@immutable
sealed class LeaveListEvent {}

class FetchLeaveListEvent extends LeaveListEvent {
  final String? startDate;
  final String? endDate;

  FetchLeaveListEvent({this.startDate, this.endDate});
}
