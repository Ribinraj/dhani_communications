part of 'fetch_approvel_dpr_bloc.dart';

@immutable
sealed class FetchApprovelDprState {}

final class FetchApprovelDprInitial extends FetchApprovelDprState {}

final class FetchApprovelDprLoading extends FetchApprovelDprState {}

final class FetchApprovelDprLoaded extends FetchApprovelDprState {
  final List<ApproveDprDataModel> approveDprList;
  FetchApprovelDprLoaded({required this.approveDprList});
}

final class FetchApprovelDprError extends FetchApprovelDprState {
  final String message;
  FetchApprovelDprError({required this.message});
}