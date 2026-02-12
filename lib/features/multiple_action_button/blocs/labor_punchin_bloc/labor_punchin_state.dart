part of 'labor_punchin_bloc.dart';

@immutable
sealed class LaborPunchInState {}

final class LaborPunchInInitial extends LaborPunchInState {}

final class LaborPunchInLoadingState extends LaborPunchInState {}

final class LaborPunchInSuccessState extends LaborPunchInState {
  final String message;

  LaborPunchInSuccessState({required this.message});
}

final class LaborPunchInErrorState extends LaborPunchInState {
  final String message;

  LaborPunchInErrorState({required this.message});
}
