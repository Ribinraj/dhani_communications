part of 'punch_in_list_bloc.dart';

@immutable
sealed class PunchInListEvent {}

class FetchPunchInListEvent extends PunchInListEvent {}
