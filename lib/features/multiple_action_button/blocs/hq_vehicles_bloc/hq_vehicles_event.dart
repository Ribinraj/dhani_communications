part of 'hq_vehicles_bloc.dart';

@immutable
sealed class HqVehiclesEvent {}

class FetchHqVehiclesEvent extends HqVehiclesEvent {}
