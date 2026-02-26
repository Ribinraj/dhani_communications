part of 'update_labour_approvel_attendence_bloc.dart';

@immutable
sealed class UpdateLabourApprovelAttendenceEvent {}

final class ApproveLabourAttendanceEvent
    extends UpdateLabourApprovelAttendenceEvent {
  final String attendanceId;
  ApproveLabourAttendanceEvent({required this.attendanceId});
}

final class RejectLabourAttendanceEvent
    extends UpdateLabourApprovelAttendenceEvent {
  final String attendanceId;
  final String approverRemarks;
  RejectLabourAttendanceEvent({
    required this.attendanceId,
    required this.approverRemarks,
  });
}
