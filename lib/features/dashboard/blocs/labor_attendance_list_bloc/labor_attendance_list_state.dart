part of 'labor_attendance_list_bloc.dart';

@immutable
sealed class LaborAttendanceListState {}

final class LaborAttendanceListInitial extends LaborAttendanceListState {}

final class LaborAttendanceListLoadingState extends LaborAttendanceListState {}

final class LaborAttendanceListSuccessState extends LaborAttendanceListState {
  final List<LaborAttendanceModel> laborAttendanceList;

  LaborAttendanceListSuccessState({required this.laborAttendanceList});
}

final class LaborAttendanceListErrorState extends LaborAttendanceListState {
  final String message;

  LaborAttendanceListErrorState({required this.message});
}
