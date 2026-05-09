part of 'new_machinery_hire_bloc.dart';

@immutable
sealed class NewMachineryHireState {}

final class NewMachineryHireInitial extends NewMachineryHireState {}

final class NewMachineryHireLoadingState extends NewMachineryHireState {}

final class NewMachineryHireSuccessState extends NewMachineryHireState {
  final String message;

  NewMachineryHireSuccessState({required this.message});
}

final class NewMachineryHireErrorState extends NewMachineryHireState {
  final String message;

  NewMachineryHireErrorState({required this.message});
}
