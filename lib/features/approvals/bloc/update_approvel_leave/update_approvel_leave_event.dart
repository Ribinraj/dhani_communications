part of 'update_approvel_leave_bloc.dart';

@immutable
sealed class UpdateApprovelLeaveEvent {}

final class ApproveLeaveEvent extends UpdateApprovelLeaveEvent {
  final String leaveId;
  ApproveLeaveEvent({required this.leaveId});
}

final class RejectLeaveEvent extends UpdateApprovelLeaveEvent {
  final String leaveId;
  final String approverRemarks;
  RejectLeaveEvent({required this.leaveId, required this.approverRemarks});
}
