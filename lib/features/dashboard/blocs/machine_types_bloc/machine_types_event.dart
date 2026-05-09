part of 'machine_types_bloc.dart';

@immutable
sealed class MachineTypesEvent {}

class FetchMachineTypesEvent extends MachineTypesEvent {}
