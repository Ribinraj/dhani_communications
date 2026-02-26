part of 'dpr_list_bloc.dart';

@immutable
sealed class DprListState {}

final class DprListInitial extends DprListState {}

final class DprListLoadingState extends DprListState {}

final class DprListSuccessState extends DprListState {
  final List<DprModel> dprList;

  DprListSuccessState({required this.dprList});
}

final class DprListErrorState extends DprListState {
  final String message;

  DprListErrorState({required this.message});
}
