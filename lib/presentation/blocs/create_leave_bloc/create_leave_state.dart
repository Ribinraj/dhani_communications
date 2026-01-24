part of 'create_leave_bloc.dart';

@immutable
sealed class CreateLeaveState {}

final class CreateLeaveInitial extends CreateLeaveState {}

final class CreateLeaveLoadingState extends CreateLeaveState {}

final class CreateLeaveSuccessState extends CreateLeaveState {
  final int? leaveId;
  final String message;

  CreateLeaveSuccessState({this.leaveId, required this.message});
}

final class CreateLeaveErrorState extends CreateLeaveState {
  final String message;

  CreateLeaveErrorState({required this.message});
}
