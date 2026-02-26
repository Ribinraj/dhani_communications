part of 'fetch_labour_approvelattendence_bloc.dart';

@immutable
sealed class FetchLabourApprovelattendenceState {}

final class FetchLabourApprovelattendenceInitial
    extends FetchLabourApprovelattendenceState {}

final class FetchLabourApprovelAttendenceLoadingState
    extends FetchLabourApprovelattendenceState {}

final class FetchLabourApprovelAttendenceSuccessState
    extends FetchLabourApprovelattendenceState {
  final List<ApprovelsLabourattendencemodel> attendence;

  FetchLabourApprovelAttendenceSuccessState({required this.attendence});
}

final class FetchLabourApprovelAttendenceErrorState
    extends FetchLabourApprovelattendenceState {
  final String message;

  FetchLabourApprovelAttendenceErrorState({required this.message});
}
