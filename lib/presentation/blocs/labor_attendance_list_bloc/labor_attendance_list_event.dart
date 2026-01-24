part of 'labor_attendance_list_bloc.dart';

@immutable
sealed class LaborAttendanceListEvent {}

class FetchLaborAttendanceListEvent extends LaborAttendanceListEvent {
  final int projectId;
  final String startDate;
  final String endDate;

  FetchLaborAttendanceListEvent({
    required this.projectId,
    required this.startDate,
    required this.endDate,
  });
}
