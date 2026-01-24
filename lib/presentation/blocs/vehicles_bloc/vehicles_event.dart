part of 'vehicles_bloc.dart';

@immutable
sealed class VehiclesEvent {}

/// Event to fetch vehicles list
class FetchVehiclesEvent extends VehiclesEvent {}

/// Event to fetch headquarter vehicles list
class FetchHeadquarterVehiclesEvent extends VehiclesEvent {}

/// Event to update vehicle information
class UpdateVehicleEvent extends VehiclesEvent {
  final int vehicleId;
  final int meterReading;
  final String vehicleNumber;

  UpdateVehicleEvent({
    required this.vehicleId,
    required this.meterReading,
    required this.vehicleNumber,
  });
}
