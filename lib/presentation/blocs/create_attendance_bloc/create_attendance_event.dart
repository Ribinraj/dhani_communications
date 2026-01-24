part of 'create_attendance_bloc.dart';

@immutable
sealed class CreateAttendanceEvent {}

class SubmitAttendanceEvent extends CreateAttendanceEvent {
  final int projectId;
  final double attendance;
  final double attendanceLatt;
  final double attendanceLong;
  final String? userRemarks;
  final String? picture;

  SubmitAttendanceEvent({
    required this.projectId,
    required this.attendance,
    required this.attendanceLatt,
    required this.attendanceLong,
    this.userRemarks,
    this.picture,
  });
}
