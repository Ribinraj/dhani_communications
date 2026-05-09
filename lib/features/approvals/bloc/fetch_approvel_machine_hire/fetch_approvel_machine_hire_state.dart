part of 'fetch_approvel_machine_hire_bloc.dart';

@immutable
sealed class FetchApprovelMachineHireState {}

final class FetchApprovelMachineHireInitial
    extends FetchApprovelMachineHireState {}

final class FetchApprovelMachineHireLoadingState
    extends FetchApprovelMachineHireState {}

final class FetchApprovelMachineHireSuccessState
    extends FetchApprovelMachineHireState {
  final List<ApprovelsMachineHireModel> machineHires;

  FetchApprovelMachineHireSuccessState({required this.machineHires});
}

final class FetchApprovelMachineHireErrorState
    extends FetchApprovelMachineHireState {
  final String message;

  FetchApprovelMachineHireErrorState({required this.message});
}
