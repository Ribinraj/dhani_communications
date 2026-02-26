part of 'updates_bloc.dart';

@immutable
sealed class UpdatesState {}

final class UpdatesInitial extends UpdatesState {}

final class UpdatesLoadingState extends UpdatesState {}

final class UpdatesSuccessState extends UpdatesState {
  final List<UpdateModel> updates;

  UpdatesSuccessState({required this.updates});
}

final class UpdatesErrorState extends UpdatesState {
  final String message;

  UpdatesErrorState({required this.message});
}
