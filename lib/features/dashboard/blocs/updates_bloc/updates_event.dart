part of 'updates_bloc.dart';

@immutable
sealed class UpdatesEvent {}

/// Event to fetch updates for home screen
class FetchUpdatesEvent extends UpdatesEvent {}
