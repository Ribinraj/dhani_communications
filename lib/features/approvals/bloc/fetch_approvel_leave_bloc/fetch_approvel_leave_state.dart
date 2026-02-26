part of 'fetch_approvel_leave_bloc.dart';

@immutable
sealed class FetchApprovelLeaveState {}

final class FetchApprovelLeaveInitial extends FetchApprovelLeaveState {}

final class FetchApprovelLeaveLoadingState extends FetchApprovelLeaveState {}

final class FetchApprovelLeaveSuccessState extends FetchApprovelLeaveState {
  final List<ApproveLeaveModel> leaves;

  FetchApprovelLeaveSuccessState({required this.leaves});
}

final class FetchApprovelLeavesErrorState extends FetchApprovelLeaveState {
  final String message;

  FetchApprovelLeavesErrorState({required this.message});
}
