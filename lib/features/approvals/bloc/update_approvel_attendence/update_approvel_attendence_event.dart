part of 'update_approvel_attendence_bloc.dart';

@immutable
sealed class UpdateApprovelAttendenceEvent {}

final class ApproveAttendanceEvent extends UpdateApprovelAttendenceEvent {
  final String attendanceId;
  ApproveAttendanceEvent({required this.attendanceId});
}

final class RejectAttendanceEvent extends UpdateApprovelAttendenceEvent {
  final String attendanceId;
  final String approverRemarks;
  RejectAttendanceEvent({
    required this.attendanceId,
    required this.approverRemarks,
  });
}
