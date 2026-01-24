part of 'attendance_check_bloc.dart';

@immutable
sealed class AttendanceCheckState {}

final class AttendanceCheckInitial extends AttendanceCheckState {}

final class AttendanceCheckLoadingState extends AttendanceCheckState {}

final class AttendanceCheckSuccessState extends AttendanceCheckState {
  final AttendanceCheckModel data;

  AttendanceCheckSuccessState({required this.data});
}

final class AttendanceCheckErrorState extends AttendanceCheckState {
  final String message;

  AttendanceCheckErrorState({required this.message});
}
