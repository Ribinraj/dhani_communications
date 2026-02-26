part of 'update_approvel_attendence_bloc.dart';

@immutable
sealed class UpdateApprovelAttendenceState {}

final class UpdateApprovelAttendenceInitial
    extends UpdateApprovelAttendenceState {}

final class UpdateApprovelAttendenceLoadingState
    extends UpdateApprovelAttendenceState {}

final class UpdateApprovelAttendenceSuccessState
    extends UpdateApprovelAttendenceState {
  final String message;
  UpdateApprovelAttendenceSuccessState({required this.message});
}

final class UpdateApprovelAttendenceErrorState
    extends UpdateApprovelAttendenceState {
  final String message;
  UpdateApprovelAttendenceErrorState({required this.message});
}
