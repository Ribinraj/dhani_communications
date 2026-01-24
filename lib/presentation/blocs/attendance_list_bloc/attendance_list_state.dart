part of 'attendance_list_bloc.dart';

@immutable
sealed class AttendanceListState {}

final class AttendanceListInitial extends AttendanceListState {}

final class AttendanceListLoadingState extends AttendanceListState {}

final class AttendanceListSuccessState extends AttendanceListState {
  final List<AttendanceModel> attendanceList;

  AttendanceListSuccessState({required this.attendanceList});
}

final class AttendanceListErrorState extends AttendanceListState {
  final String message;

  AttendanceListErrorState({required this.message});
}
