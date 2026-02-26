part of 'dpr_details_bloc.dart';

@immutable
sealed class DprDetailsEvent {}

class FetchDprDetailsEvent extends DprDetailsEvent {
  final int dprId;

  FetchDprDetailsEvent({required this.dprId});
}
