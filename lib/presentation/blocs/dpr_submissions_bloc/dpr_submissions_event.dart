part of 'dpr_submissions_bloc.dart';

@immutable
sealed class DprSubmissionsEvent {}

class FetchDprSubmissionsEvent extends DprSubmissionsEvent {
  final int projectId;
  final String startDate;
  final String endDate;

  FetchDprSubmissionsEvent({
    required this.projectId,
    required this.startDate,
    required this.endDate,
  });
}
