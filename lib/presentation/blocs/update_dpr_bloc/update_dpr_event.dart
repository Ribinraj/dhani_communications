part of 'update_dpr_bloc.dart';

@immutable
sealed class UpdateDprEvent {}

class SubmitDprUpdateEvent extends UpdateDprEvent {
  final int? dprId;
  final int projectId;
  final String dprDate;
  final int progress;
  final String? userRemarks;

  SubmitDprUpdateEvent({
    this.dprId,
    required this.projectId,
    required this.dprDate,
    required this.progress,
    this.userRemarks,
  });
}
