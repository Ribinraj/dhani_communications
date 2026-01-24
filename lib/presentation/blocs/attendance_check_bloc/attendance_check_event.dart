part of 'attendance_check_bloc.dart';

@immutable
sealed class AttendanceCheckEvent {}

class CheckAttendanceEvent extends AttendanceCheckEvent {}
