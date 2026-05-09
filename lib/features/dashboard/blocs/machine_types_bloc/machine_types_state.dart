part of 'machine_types_bloc.dart';

@immutable
sealed class MachineTypesState {}

final class MachineTypesInitial extends MachineTypesState {}

final class MachineTypesLoadingState extends MachineTypesState {}

final class MachineTypesSuccessState extends MachineTypesState {
  final List<MachineTypeModel> machineTypes;

  MachineTypesSuccessState({required this.machineTypes});
}

final class MachineTypesErrorState extends MachineTypesState {
  final String message;

  MachineTypesErrorState({required this.message});
}
