part of 'new_machinery_hire_bloc.dart';

@immutable
sealed class NewMachineryHireEvent {}

class SubmitNewMachineryHireEvent extends NewMachineryHireEvent {
  final NewMachineryHireRequestModel machineryHire;

  SubmitNewMachineryHireEvent({required this.machineryHire});
}
