part of 'new_attendance_check_bloc.dart';

@immutable
sealed class NewAttendanceCheckState {}

final class NewAttendanceCheckInitial extends NewAttendanceCheckState {}

final class NewAttendanceCheckLoadingState extends NewAttendanceCheckState {}

final class NewAttendanceCheckSuccessState extends NewAttendanceCheckState {
  final AttendanceCheckResponseModel data;

  NewAttendanceCheckSuccessState({required this.data});
}

final class NewAttendanceCheckErrorState extends NewAttendanceCheckState {
  final String message;

  NewAttendanceCheckErrorState({required this.message});
}
