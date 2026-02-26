part of 'attendance_list_bloc.dart';

@immutable
sealed class AttendanceListEvent {}

class FetchAttendanceListEvent extends AttendanceListEvent {
  final String? startDate;
  final String? endDate;

  FetchAttendanceListEvent({this.startDate, this.endDate});
}
