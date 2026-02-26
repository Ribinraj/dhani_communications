part of 'labor_attendance_list_bloc.dart';

@immutable
sealed class LaborAttendanceListEvent {}

class FetchLaborAttendanceListEvent extends LaborAttendanceListEvent {
  final String? startDate;
  final String? endDate;

  FetchLaborAttendanceListEvent({this.startDate, this.endDate});
}
