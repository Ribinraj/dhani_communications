part of 'update_machine_hire_approval_bloc.dart';

@immutable
sealed class UpdateMachineHireApprovalState {}

final class UpdateMachineHireApprovalInitial
    extends UpdateMachineHireApprovalState {}

final class UpdateMachineHireApprovalLoadingState
    extends UpdateMachineHireApprovalState {}

final class UpdateMachineHireApprovalSuccessState
    extends UpdateMachineHireApprovalState {
  final String message;

  UpdateMachineHireApprovalSuccessState({required this.message});
}

final class UpdateMachineHireApprovalErrorState
    extends UpdateMachineHireApprovalState {
  final String message;

  UpdateMachineHireApprovalErrorState({required this.message});
}
