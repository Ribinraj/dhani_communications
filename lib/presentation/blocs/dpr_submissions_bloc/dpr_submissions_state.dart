part of 'dpr_submissions_bloc.dart';

@immutable
sealed class DprSubmissionsState {}

final class DprSubmissionsInitial extends DprSubmissionsState {}

final class DprSubmissionsLoadingState extends DprSubmissionsState {}

final class DprSubmissionsSuccessState extends DprSubmissionsState {
  final List<DprSubmissionModel> submissions;

  DprSubmissionsSuccessState({required this.submissions});
}

final class DprSubmissionsErrorState extends DprSubmissionsState {
  final String message;

  DprSubmissionsErrorState({required this.message});
}
