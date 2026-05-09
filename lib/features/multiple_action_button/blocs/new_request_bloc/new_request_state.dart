part of 'new_request_bloc.dart';

@immutable
sealed class NewRequestState {}

final class NewRequestInitial extends NewRequestState {}

final class NewRequestLoadingState extends NewRequestState {}

final class NewRequestSuccessState extends NewRequestState {
  final String message;

  NewRequestSuccessState({required this.message});
}

final class NewRequestErrorState extends NewRequestState {
  final String message;

  NewRequestErrorState({required this.message});
}
