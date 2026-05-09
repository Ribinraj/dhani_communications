part of 'fetch_approvel_machine_hire_bloc.dart';

@immutable
sealed class FetchApprovelMachineHireEvent {}

final class FetchApprovelMachineHireInitialEvent
    extends FetchApprovelMachineHireEvent {
  final String? filterFrom;
  final String? filterTo;

  FetchApprovelMachineHireInitialEvent({this.filterFrom, this.filterTo});
}
