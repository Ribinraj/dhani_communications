part of 'update_labour_approvel_attendence_bloc.dart';

@immutable
sealed class UpdateLabourApprovelAttendenceState {}

final class UpdateLabourApprovelAttendenceInitial
    extends UpdateLabourApprovelAttendenceState {}

final class UpdateLabourApprovelAttendenceLoadingState
    extends UpdateLabourApprovelAttendenceState {}

final class UpdateLabourApprovelAttendenceSuccessState
    extends UpdateLabourApprovelAttendenceState {
  final String message;
  UpdateLabourApprovelAttendenceSuccessState({required this.message});
}

final class UpdateLabourApprovelAttendenceErrorState
    extends UpdateLabourApprovelAttendenceState {
  final String message;
  UpdateLabourApprovelAttendenceErrorState({required this.message});
}
