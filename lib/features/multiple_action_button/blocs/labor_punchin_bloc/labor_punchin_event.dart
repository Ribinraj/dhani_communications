part of 'labor_punchin_bloc.dart';

@immutable
sealed class LaborPunchInEvent {}

class LaborPunchInSubmitEvent extends LaborPunchInEvent {
  final LaborAttendanceRequestModel laborAttendance;

  LaborPunchInSubmitEvent({required this.laborAttendance});
}

class LaborPunchOutSubmitEvent extends LaborPunchInEvent {
  final LaborPunchOutRequestModel punchOut;

  LaborPunchOutSubmitEvent({required this.punchOut});
}
