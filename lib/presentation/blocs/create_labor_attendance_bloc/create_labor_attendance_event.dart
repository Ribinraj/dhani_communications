part of 'create_labor_attendance_bloc.dart';

@immutable
sealed class CreateLaborAttendanceEvent {}

class SubmitLaborAttendanceEvent extends CreateLaborAttendanceEvent {
  final int projectId;
  final String laborName;
  final String laborMobile;
  final String laborType;
  final String attendanceDate;
  final String punchInTime;
  final double punchInLatt;
  final double punchInLong;
  final String? userRemarks;
  final String? picture;

  SubmitLaborAttendanceEvent({
    required this.projectId,
    required this.laborName,
    required this.laborMobile,
    required this.laborType,
    required this.attendanceDate,
    required this.punchInTime,
    required this.punchInLatt,
    required this.punchInLong,
    this.userRemarks,
    this.picture,
  });
}
