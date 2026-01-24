part of 'create_labor_attendance_bloc.dart';

@immutable
sealed class CreateLaborAttendanceState {}

final class CreateLaborAttendanceInitial extends CreateLaborAttendanceState {}

final class CreateLaborAttendanceLoadingState extends CreateLaborAttendanceState {}

final class CreateLaborAttendanceSuccessState extends CreateLaborAttendanceState {
  final int? laborAttendanceId;
  final String message;

  CreateLaborAttendanceSuccessState({this.laborAttendanceId, required this.message});
}

final class CreateLaborAttendanceErrorState extends CreateLaborAttendanceState {
  final String message;

  CreateLaborAttendanceErrorState({required this.message});
}
