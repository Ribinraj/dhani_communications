part of 'get_machines_bloc.dart';

@immutable
sealed class GetMachinesState {}

final class GetMachinesInitial extends GetMachinesState {}

final class GetMachinesLoadingState extends GetMachinesState {}

final class GetMachinesSuccessState extends GetMachinesState {
  final List<MachineHireModel> machinelist;

  GetMachinesSuccessState({required this.machinelist});
}

final class GetMachinesErrorState extends GetMachinesState {
  final String message;

  GetMachinesErrorState({required this.message});
}
