part of 'new_leave_bloc.dart';

@immutable
sealed class NewLeaveState {}

final class NewLeaveInitial extends NewLeaveState {}

final class NewLeaveLoadingState extends NewLeaveState {}

final class NewLeaveSuccessState extends NewLeaveState {
  final String message;

  NewLeaveSuccessState({required this.message});
}

final class NewLeaveErrorState extends NewLeaveState {
  final String message;

  NewLeaveErrorState({required this.message});
}
