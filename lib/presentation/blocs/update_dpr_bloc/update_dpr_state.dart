part of 'update_dpr_bloc.dart';

@immutable
sealed class UpdateDprState {}

final class UpdateDprInitial extends UpdateDprState {}

final class UpdateDprLoadingState extends UpdateDprState {}

final class UpdateDprSuccessState extends UpdateDprState {
  final int? dprId;
  final String message;

  UpdateDprSuccessState({this.dprId, required this.message});
}

final class UpdateDprErrorState extends UpdateDprState {
  final String message;

  UpdateDprErrorState({required this.message});
}
