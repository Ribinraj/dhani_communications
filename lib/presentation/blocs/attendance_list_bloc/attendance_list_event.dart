part of 'attendance_list_bloc.dart';

@immutable
sealed class AttendanceListEvent {}

class FetchAttendanceListEvent extends AttendanceListEvent {
  final int projectId;
  final String startDate;
  final String endDate;

  FetchAttendanceListEvent({
    required this.projectId,
    required this.startDate,
    required this.endDate,
  });
}
