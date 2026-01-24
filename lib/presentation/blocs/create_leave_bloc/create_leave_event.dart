part of 'create_leave_bloc.dart';

@immutable
sealed class CreateLeaveEvent {}

class SubmitLeaveEvent extends CreateLeaveEvent {
  final int projectId;
  final int leaveCategoryId;
  final String leaveFromDate;
  final String leaveToDate;
  final String? userRemarks;
  final double? leaveLatt;
  final double? leaveLong;
  final String? picture;

  SubmitLeaveEvent({
    required this.projectId,
    required this.leaveCategoryId,
    required this.leaveFromDate,
    required this.leaveToDate,
    this.userRemarks,
    this.leaveLatt,
    this.leaveLong,
    this.picture,
  });
}
