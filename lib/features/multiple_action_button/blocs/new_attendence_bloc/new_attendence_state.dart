part of 'new_attendence_bloc.dart';

@immutable
sealed class NewAttendenceState {}

final class NewAttendenceInitial extends NewAttendenceState {}

final class NewAttendenceLoadingState extends NewAttendenceState {}

final class NewAttendenceSuccessState extends NewAttendenceState {
  final String message;

  NewAttendenceSuccessState({required this.message});
}

final class NewAttendenceErrorState extends NewAttendenceState {
  final String message;

  NewAttendenceErrorState({required this.message});
}
