part of 'request_list_bloc.dart';

@immutable
sealed class RequestListState {}

final class RequestListInitial extends RequestListState {}

final class RequestListLoadingState extends RequestListState {}

final class RequestListSuccessState extends RequestListState {
  final List<RequestModel> requestList;

  RequestListSuccessState({required this.requestList});
}

final class RequestListErrorState extends RequestListState {
  final String message;

  RequestListErrorState({required this.message});
}
