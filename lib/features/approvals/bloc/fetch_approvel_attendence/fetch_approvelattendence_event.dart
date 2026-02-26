part of 'fetch_approvelattendence_bloc.dart';

@immutable
sealed class FetchApprovelattendenceEvent {}
final class FetchApprovelAttendenceInitialFetchingEvent extends FetchApprovelattendenceEvent{}