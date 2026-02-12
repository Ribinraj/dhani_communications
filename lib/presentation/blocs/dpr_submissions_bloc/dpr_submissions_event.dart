part of 'dpr_submissions_bloc.dart';

@immutable
sealed class DprSubmissionsEvent {}

class FetchDprSubmissionsEvent extends DprSubmissionsEvent {
  final String? startDate;
  final String? endDate;

  FetchDprSubmissionsEvent({this.startDate, this.endDate});
}
