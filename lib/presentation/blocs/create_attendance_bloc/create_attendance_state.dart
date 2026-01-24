part of 'create_attendance_bloc.dart';

@immutable
sealed class CreateAttendanceState {}

final class CreateAttendanceInitial extends CreateAttendanceState {}

final class CreateAttendanceLoadingState extends CreateAttendanceState {}

final class CreateAttendanceSuccessState extends CreateAttendanceState {
  final int? attendanceId;
  final String message;

  CreateAttendanceSuccessState({this.attendanceId, required this.message});
}

final class CreateAttendanceErrorState extends CreateAttendanceState {
  final String message;

  CreateAttendanceErrorState({required this.message});
}
