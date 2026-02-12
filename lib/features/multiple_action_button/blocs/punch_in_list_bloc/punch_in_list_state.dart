part of 'punch_in_list_bloc.dart';

@immutable
sealed class PunchInListState {}

final class PunchInListInitial extends PunchInListState {}

final class PunchInListLoadingState extends PunchInListState {}

final class PunchInListSuccessState extends PunchInListState {
  final List<PunchInListModel> punchInList;

  PunchInListSuccessState({required this.punchInList});
}

final class PunchInListErrorState extends PunchInListState {
  final String message;

  PunchInListErrorState({required this.message});
}
