part of 'update_approvel_dpr_bloc.dart';

@immutable
sealed class UpdateApprovelDprEvent {}

final class ApproveDprEvent extends UpdateApprovelDprEvent {
  final String progressId;
  ApproveDprEvent({required this.progressId});
}

final class RejectDprEvent extends UpdateApprovelDprEvent {
  final String progressId;
  final String approverRemarks;
  RejectDprEvent({required this.progressId, required this.approverRemarks});
}
