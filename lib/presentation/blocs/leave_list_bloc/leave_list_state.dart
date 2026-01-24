part of 'leave_list_bloc.dart';

@immutable
sealed class LeaveListState {}

final class LeaveListInitial extends LeaveListState {}

final class LeaveListLoadingState extends LeaveListState {}

final class LeaveListSuccessState extends LeaveListState {
  final List<LeaveModel> leavesList;

  LeaveListSuccessState({required this.leavesList});
}

final class LeaveListErrorState extends LeaveListState {
  final String message;

  LeaveListErrorState({required this.message});
}
