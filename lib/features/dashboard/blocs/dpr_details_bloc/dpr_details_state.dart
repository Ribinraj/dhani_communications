part of 'dpr_details_bloc.dart';

@immutable
sealed class DprDetailsState {}

final class DprDetailsInitial extends DprDetailsState {}

final class DprDetailsLoadingState extends DprDetailsState {}

final class DprDetailsSuccessState extends DprDetailsState {
  final DprDetailsModel dprDetails;

  DprDetailsSuccessState({required this.dprDetails});
}

final class DprDetailsErrorState extends DprDetailsState {
  final String message;

  DprDetailsErrorState({required this.message});
}
