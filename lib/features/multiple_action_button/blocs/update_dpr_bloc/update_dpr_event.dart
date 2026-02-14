part of 'update_dpr_bloc.dart';

@immutable
sealed class UpdateDprEvent {}

class SubmitDprUpdateEvent extends UpdateDprEvent {
  final DprUpdateModel dprupdatedata;

  SubmitDprUpdateEvent({required this.dprupdatedata});


}
