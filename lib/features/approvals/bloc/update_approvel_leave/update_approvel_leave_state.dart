part of 'update_approvel_leave_bloc.dart';

@immutable
sealed class UpdateApprovelLeaveState {}

final class UpdateApprovelLeaveInitial extends UpdateApprovelLeaveState {}

final class UpdateApprovelLeaveLoadingState extends UpdateApprovelLeaveState {}

final class UpdateApprovelLeaveSuccessState extends UpdateApprovelLeaveState {
  final String message;
  UpdateApprovelLeaveSuccessState({required this.message});
}

final class UpdateApprovelLeaveErrorState extends UpdateApprovelLeaveState {
  final String message;
  UpdateApprovelLeaveErrorState({required this.message});
}
