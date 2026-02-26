part of 'fetch_approvelattendence_bloc.dart';

@immutable
sealed class FetchApprovelattendenceState {}

final class FetchApprovelattendenceInitial
    extends FetchApprovelattendenceState {}

final class FetchApprovelAttendenceLoadingState
    extends FetchApprovelattendenceState {}

final class FetchApprovelAttendenceSuccessState
    extends FetchApprovelattendenceState {
  final List<ApprovelsAttendencemodel> attendence;

  FetchApprovelAttendenceSuccessState({required this.attendence});
}

final class FetchApproveAttendenceErrorState
    extends FetchApprovelattendenceState {
  final String message;

  FetchApproveAttendenceErrorState({required this.message});
}
