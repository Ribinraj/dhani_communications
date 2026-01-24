part of 'vehicles_bloc.dart';

@immutable
sealed class VehiclesState {}

final class VehiclesInitial extends VehiclesState {}

// States for fetching user vehicles
final class VehiclesLoadingState extends VehiclesState {}

final class VehiclesSuccessState extends VehiclesState {
  final List<VehicleModel> vehicles;

  VehiclesSuccessState({required this.vehicles});
}

final class VehiclesErrorState extends VehiclesState {
  final String message;

  VehiclesErrorState({required this.message});
}

// States for fetching headquarter vehicles
final class HeadquarterVehiclesLoadingState extends VehiclesState {}

final class HeadquarterVehiclesSuccessState extends VehiclesState {
  final List<HeadquarterVehicleModel> vehicles;

  HeadquarterVehiclesSuccessState({required this.vehicles});
}

final class HeadquarterVehiclesErrorState extends VehiclesState {
  final String message;

  HeadquarterVehiclesErrorState({required this.message});
}

// States for updating vehicle
final class UpdateVehicleLoadingState extends VehiclesState {}

final class UpdateVehicleSuccessState extends VehiclesState {
  final String message;

  UpdateVehicleSuccessState({required this.message});
}

final class UpdateVehicleErrorState extends VehiclesState {
  final String message;

  UpdateVehicleErrorState({required this.message});
}
