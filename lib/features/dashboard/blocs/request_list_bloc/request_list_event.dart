part of 'request_list_bloc.dart';

@immutable
sealed class RequestListEvent {}

class FetchRequestListEvent extends RequestListEvent {}
