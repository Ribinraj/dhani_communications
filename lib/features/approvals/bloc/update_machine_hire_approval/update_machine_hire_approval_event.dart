part of 'update_machine_hire_approval_bloc.dart';

@immutable
sealed class UpdateMachineHireApprovalEvent {}

final class ApproveMachineHireEvent extends UpdateMachineHireApprovalEvent {
  final String hireId;

  ApproveMachineHireEvent({required this.hireId});
}

final class RejectMachineHireEvent extends UpdateMachineHireApprovalEvent {
  final String hireId;
  final String approverRemarks;

  RejectMachineHireEvent({required this.hireId, required this.approverRemarks});
}
