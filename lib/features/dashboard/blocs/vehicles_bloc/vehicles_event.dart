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
  final double vehicleLastServiceKm;
  final String vehicleLastServiceDate;
  final String vehiclePucValidity;
  final String vehicleInsuranceValidity;

  UpdateVehicleEvent({
    required this.vehicleId,
    required this.vehicleLastServiceKm,
    required this.vehicleLastServiceDate,
    required this.vehiclePucValidity,
    required this.vehicleInsuranceValidity,
  });
}
