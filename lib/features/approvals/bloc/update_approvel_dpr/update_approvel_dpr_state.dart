part of 'update_approvel_dpr_bloc.dart';

@immutable
sealed class UpdateApprovelDprState {}

final class UpdateApprovelDprInitial extends UpdateApprovelDprState {}

final class UpdateApprovelDprLoadingState extends UpdateApprovelDprState {}

final class UpdateApprovelDprSuccessState extends UpdateApprovelDprState {
  final String message;
  UpdateApprovelDprSuccessState({required this.message});
}

final class UpdateApprovelDprErrorState extends UpdateApprovelDprState {
  final String message;
  UpdateApprovelDprErrorState({required this.message});
}
