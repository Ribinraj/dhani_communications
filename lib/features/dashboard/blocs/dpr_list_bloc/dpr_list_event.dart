part of 'dpr_list_bloc.dart';

@immutable
sealed class DprListEvent {}

class FetchDprListEvent extends DprListEvent {
  final int projectId;

  FetchDprListEvent({required this.projectId});
}
