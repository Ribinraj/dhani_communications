part of 'get_machines_bloc.dart';

@immutable
sealed class GetMachinesEvent {}

final class GetMachinesInitialFetchingEvent extends GetMachinesEvent {
  final String? startDate;
  final String? endDate;

  GetMachinesInitialFetchingEvent({this.startDate, this.endDate});
}
