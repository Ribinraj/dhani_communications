part of 'new_attendence_bloc.dart';

@immutable
sealed class NewAttendenceEvent {}

final class NewAttendenceMarkingEvent extends NewAttendenceEvent {
  final AttendanceRequestModel attendence;

  NewAttendenceMarkingEvent({required this.attendence});
}
