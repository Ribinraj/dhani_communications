part of 'dpr_list_bloc.dart';

@immutable
sealed class DprListEvent {}

class FetchDprListEvent extends DprListEvent {
  final int projectId;
  final String startDate;
  final String endDate;

  FetchDprListEvent({
    required this.projectId,
    required this.startDate,
    required this.endDate,
  });
}
